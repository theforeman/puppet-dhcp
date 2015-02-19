define dhcp::pool (
  $network,
  $mask,
  $gateway     = undef,
  $range       = undef,
  $options     = undef,
  $parameters  = undef,
  $nameservers = undef,
  $pxeserver   = undef,
  $domain_name = undef,
) {

  concat_fragment { "dhcp.conf+70_${name}.dhcp":
    content => template('dhcp/dhcpd.pool.erb'),
  }

}
