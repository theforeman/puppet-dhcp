class dhcp (
  $dnsdomain          = $dhcp::params::dnsdomain,
  $nameservers        = ['8.8.8.8', '8.8.4.4'],
  $failover           = false,
  $bootp              = undef,
  $ntpservers         = [],
  $interfaces         = undef,
  $interface          = 'NOTSET',
  $default_lease_time = 43200,
  $max_lease_time     = 86400,
  $dnskeyname         = 'rndc-key',
  $dnsupdatekey       = undef,
  $omapi              = true,
  $omapi_name         = undef,
  $omapi_key          = undef,
  $pxeserver          = undef,
  $pxefilename        = $dhcp::params::pxefilename,
  $mtu                = undef,
  $bootfiles          = $dhcp::params::bootfiles,
  $logfacility        = 'local7',
  $dhcp_monitor       = true,
  $dhcp_dir           = $dhcp::params::dhcp_dir,
  $packagename        = $dhcp::params::packagename,
  $servicename        = $dhcp::params::servicename,
  $option_static_route = undef,
  $options            = undef,
  $authoritative      = false,
  $dhcp_root_group    = $dhcp::params::root_group,
  $ddns_updates       = false,
  $ddns_domainname    = undef,
  $ddns_rev_domainname= undef,
  $pools              = {},
  $hosts              = {},
  $includes           = undef,
) inherits dhcp::params {

  if $mtu {
    validate_integer($mtu)
  }
  validate_hash($bootfiles)

  # Incase people set interface instead of interfaces work around
  # that. If they set both, use interfaces and the user is a unwise
  # and deserves what they get.
  if $interface != 'NOTSET' and $interfaces == undef {
    $dhcp_interfaces = [ $interface ]
  } elsif $interface == 'NOTSET' and $interfaces == undef {
    fail ("You need to set \$interfaces in ${module_name}")
  } else {
    $dhcp_interfaces = $interfaces
  }

  # See https://tools.ietf.org/html/draft-ietf-dhc-failover-12 for why BOOTP is
  # not supported in the failover protocol. Relay agents *can* be made to work
  # so $bootp can be explicitly set to true to override this default.
  if $bootp == undef {
    $bootp_real = !$failover
  } else {
    $bootp_real = $bootp
  }

  package { $packagename:
    ensure   => installed,
  }

  file { $dhcp_dir:
    mode    => '0755',
    require => Package[$packagename],
  }

  # Only debian and ubuntu have this style of defaults for startup.
  case $::osfamily {
    'Debian': {
      file{ '/etc/default/isc-dhcp-server':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        before  => Package[$packagename],
        notify  => Service[$servicename],
        content => template('dhcp/debian/default_isc-dhcp-server'),
      }
    }
    'RedHat': {
      file{ '/etc/sysconfig/dhcpd':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        before  => Package[$packagename],
        notify  => Service[$servicename],
        content => template('dhcp/redhat/sysconfig-dhcpd'),
      }
      if $::operatingsystemrelease =~ /^7/ and $interfaces != undef {
        file{ '/etc/systemd/system/dhcpd.service':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          require => Package[$packagename],
          notify  => Exec['systemctl-daemon-reload-dhcp'],
          content => template('dhcp/redhat/dhcpd.service'),
        }
        exec { 'systemctl-daemon-reload-dhcp':
          path        => '/usr/bin',
          command     => 'systemctl --system daemon-reload',
          user        => 'root',
          notify      => Service[$servicename],
          refreshonly => true,
        }
      }
    }
    /^(FreeBSD|DragonFly)$/: {
      $interfaces_line = join($dhcp_interfaces, ' ')
      augeas { 'set listen interfaces':
        context => '/files/etc/rc.conf',
        changes => "set dhcpd_ifaces '\"${interfaces_line}\"'",
        before  => Package[$packagename],
        notify  => Service[$servicename],
      }
    }
    default: {
    }
  }

  concat { "${dhcp_dir}/dhcpd.conf":
    owner   => 'root',
    group   => $dhcp_root_group,
    mode    => '0644',
    require => Package[$packagename],
    notify  => Service[$servicename],
  }

  concat::fragment { 'dhcp.conf+01_main.dhcp':
    target  => "${dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.conf.erb'),
    order   => '01',
  }

  if $includes {
    concat::fragment { 'dhcp.conf+20_includes':
      target  => "${dhcp_dir}/dhcpd.conf",
      content => template('dhcp/dhcpd.conf.includes.erb'),
      order   => '20',
    }
  }

  concat { "${dhcp_dir}/dhcpd.hosts":
    owner   => 'root',
    group   => $dhcp_root_group,
    mode    => '0644',
    require => Package[$packagename],
    notify  => Service[$servicename],
  }

  concat::fragment { 'dhcp.hosts+01_main.hosts':
    target  => "${dhcp_dir}/dhcpd.hosts",
    content => "# static DHCP hosts\n",
    order   => '01',
  }

  create_resources('dhcp::pool', $pools)
  create_resources('dhcp::host', $hosts)

  service { $servicename:
    ensure => running,
    enable => true,
  }
}
