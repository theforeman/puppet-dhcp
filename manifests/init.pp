# Manage an ISC DHCP server
class dhcp (
  Array[String] $dnsdomain = $dhcp::params::dnsdomain,
  Array[String] $nameservers = ['8.8.8.8', '8.8.4.4'],
  Boolean $failover = false,
  Optional[Boolean] $bootp = undef,
  Array[String] $ntpservers = [],
  Optional[Array[String]] $interfaces = undef,
  String $interface = 'NOTSET',
  Integer[0] $default_lease_time = 43200,
  Integer[0] $max_lease_time = 86400,
  String $dnskeyname = 'rndc-key',
  Optional[String] $dnsupdatekey = undef,
  Optional[String] $dnsupdateserver = undef,
  Boolean $omapi = true,
  Optional[String] $omapi_name = undef,
  String $omapi_algorithm = 'HMAC-MD5',
  Optional[String] $omapi_key = undef,
  Optional[String] $pxeserver = undef,
  String $pxefilename = $dhcp::params::pxefilename,
  Optional[Integer[0]] $mtu  = undef,
  Hash[String, String] $bootfiles = $dhcp::params::bootfiles,
  String $logfacility = 'local7',
  Boolean $dhcp_monitor = true,
  Stdlib::Absolutepath $dhcp_dir = $dhcp::params::dhcp_dir,
  String $packagename = $dhcp::params::packagename,
  String $servicename = $dhcp::params::servicename,
  $option_static_route = undef,
  Variant[Array[String], Optional[String]] $options = undef,
  Boolean $authoritative = false,
  String $dhcp_root_group = $dhcp::params::root_group,
  Boolean $ddns_updates = false,
  Optional[String] $ddns_domainname = undef,
  Optional[String] $ddns_rev_domainname = undef,
  Enum['none', 'interim', 'standard'] $ddns_update_style = 'interim',
  Hash[String, Hash] $pools = {},
  Hash[String, Hash] $hosts = {},
  Variant[Array[String], Optional[String]] $includes = undef,
  String $config_comment = 'dhcpd.conf',
  Enum['running', 'unmanaged', 'stopped'] $service_ensure = 'running',
) inherits dhcp::params {

  # In case people set interface instead of interfaces work around
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

  $dnsupdateserver_real = pick($dnsupdateserver, $nameservers[0])

  package { $packagename:
    ensure   => installed,
  }

  file { $dhcp_dir:
    mode    => '0755',
    require => Package[$packagename],
  }

  # Only debian and ubuntu have this style of defaults for startup.
  case $facts['osfamily'] {
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
      if versioncmp($facts['operatingsystemmajrelease'], '7') >= 0 {
        include systemd
        systemd::dropin_file { 'interfaces.conf':
          unit    => 'dhcpd.service',
          content => template('dhcp/redhat/systemd-dropin.conf.erb'),
        }
      } else {
        file { '/etc/sysconfig/dhcpd':
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          before  => Package[$packagename],
          notify  => Service[$servicename],
          content => template('dhcp/redhat/sysconfig-dhcpd'),
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

  $_service_ensure_real = $service_ensure ? {
    'unmanaged' => undef,
    default     => $service_ensure,
  }
  
  service { $servicename:
    ensure => $service_ensure,
    enable => true,
  }
}
