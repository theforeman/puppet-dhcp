define dhcp::pool (
  $network,
  $mask,
  $range = false,
  $gateway = false,
  $nameservers = undef,
  $pxeserver = undef,
) {

  concat_fragment { "dhcp.conf+70_${name}.dhcp":
    content => template('dhcp/dhcpd.pool.erb'),
  }

}
