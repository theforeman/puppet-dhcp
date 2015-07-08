class dhcp (
  $dnsdomain          = $dhcp::params::dnsdomain,
  $nameservers        = ['8.8.8.8', '8.8.4.4'],
  $interfaces         = undef,
  $interface          = 'NOTSET',
  $default_lease_time = 43200,
  $max_lease_time     = 86400,
  $dnskeyname         = 'rndc-key',
  $dnsupdatekey       = undef,
  $pxeserver          = undef,
  $pxefilename        = undef,
  $logfacility        = 'local7',
  $dhcp_monitor       = true,
  $dhcp_dir           = $dhcp::params::dhcp_dir,
  $packagename        = $dhcp::params::packagename,
  $servicename        = $dhcp::params::servicename,
  $option_static_route = undef,
  $authoritative      = false,
) inherits dhcp::params {

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

  $package_provider = $::operatingsystem ? {
    'darwin'  => 'macports',
    default => undef,
  }

  package { $packagename:
    ensure   => installed,
    provider => $package_provider,
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
    }
    default: {
      fail("Unsupported OS family ${::osfamily}")
    }
  }

  concat { "${dhcp_dir}/dhcpd.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$packagename],
    notify  => Service[$servicename],
  }

  concat::fragment { 'dhcp.conf+01_main.dhcp':
    target  => "${dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.conf.erb'),
    order   => '01',
  }

  concat { "${dhcp_dir}/dhcpd.hosts":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$packagename],
    notify  => Service[$servicename],
  }

  concat::fragment { 'dhcp.hosts+01_main.hosts':
    target  => "${dhcp_dir}/dhcpd.hosts",
    content => "# static DHCP hosts\n",
    order   => '01',
  }

  service { $servicename:
    ensure => running,
    enable => true,
  }
}
