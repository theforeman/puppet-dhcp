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
  $pxefilename     = undef,
  $domain_name     = undef,
  $static_routes   = undef,
  $search_domains  = undef,
  $raw_append      = undef,
  $raw_prepend     = undef,
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
