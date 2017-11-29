# class dhcp::dhcp6
class dhcp::dhcp6 (
  Array[String] $nameservers = ['2001:4860:4860::8888', '2001:4860:4860::8844'],
  Integer[0] $default_lease_time6 = 2592000,
  Integer[0] $default_preferred_lifetime6 = 604800,
  Integer[0] $default_renewal_time6 = 3600,
  Integer[0] $default_rebinding_time6 = 7200,
  Integer[0] $default_info_refresh_time6 = 21600,
  Boolean $leasequery6 = true,
  Boolean $rapid_commit6 = false,
  Integer[0] $default_preference6 = 10,
  Stdlib::Absolutepath $dhcp_dir = $dhcp::params::dhcp_dir,
  String $dhcp_conf6 = $dhcp::params::dhcp_conf6,
  String $packagename = $dhcp::params::packagename,
  String $servicename6 = $dhcp::params::servicename6,
  Variant[Array[String], Optional[String]] $options = undef,
  String $dhcp_root_group = $dhcp::params::root_group,
  Hash[String, Hash] $pools6 = {},
  Hash[String, Hash] $hosts6 = {},
  Variant[Array[String], Optional[String]] $includes = undef,
) inherits dhcp::params {

  concat { "${dhcp_dir}/dhcpd6.conf":
    owner   => 'root',
    group   => $dhcp_root_group,
    mode    => '0644',
    require => Package[$packagename],
    notify  => Service[$servicename6],
  }

  concat::fragment { 'dhcp6.conf+01_main.dhcp':
    target  => "${dhcp_dir}/${dhcp_conf6}.conf",
    content => template('dhcp/dhcpd6.conf.erb'),
    order   => '01',
  }

  if $includes {
    concat::fragment { 'dhcp6.conf+20_includes':
      target  => "${dhcp_dir}/${dhcp_conf6}.conf",
      content => template('dhcp/dhcpd6.conf.includes.erb'),
      order   => '20',
    }
  }

  concat { "${dhcp_dir}/dhcpd6.hosts":
    owner   => 'root',
    group   => $dhcp_root_group,
    mode    => '0644',
    require => Package[$packagename],
    notify  => Service[$servicename6],
  }

  concat::fragment { 'dhcp6.hosts+01_main.hosts':
    target  => "${dhcp_dir}/${dhcp_conf6}.hosts",
    content => "# static DHCP hosts\n",
    order   => '01',
  }

  create_resources('dhcp::pool6', $pools6)
  create_resources('dhcp::host6', $hosts6)

  if ! defined(Service[$servicename6]){
    service { $servicename6:
      ensure => running,
      enable => true,
    }
  }
}
