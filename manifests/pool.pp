define dhcp::pool (
  $network,
  $mask,
  $gateway         = undef,
  $pool_parameters = undef,
  $range           = undef,
  $failover        = undef,
  $options         = undef,
  $parameters      = undef,
  $mtu             = undef,
  $nameservers     = undef,
  $pxeserver       = undef,
  $domain_name     = undef,
  $static_routes   = undef,
  $search_domains  = undef,
) {

  if $mtu {
    validate_integer($mtu)
  }

  concat::fragment { "dhcp.conf+70_${name}.dhcp":
    target  => "${::dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.pool.erb'),
    order   => "70-${name}",
  }

}
