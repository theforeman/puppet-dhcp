define dhcp::pool (
  $network,
  $mask,
  $range = false,
  $gateway = false,
  $nameservers = undef,
  $pxeserver = undef,
) {

  include dhcp::params

  $dhcp_dir = $dhcp::params::dhcp_dir

  concat_fragment { "dhcp.conf+70_${name}.dhcp":
    content => template('dhcp/dhcpd.pool.erb'),
  }

}
