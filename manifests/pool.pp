define dhcp::pool (
  $network,
  $mask,
  $gateway     = '',
  $range       = '',
  $options     = '',
  $parameters  = '',
  $nameservers = undef,
  $pxeserver   = undef,
) {

  concat_fragment { "dhcp.conf+70_${name}.dhcp":
    content => template('dhcp/dhcpd.pool.erb'),
  }

}
