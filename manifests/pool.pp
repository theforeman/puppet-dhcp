define dhcp::pool (
  $network,
  $mask,
  $gateway         = undef,
  $pool_parameters = undef,
  $range           = undef,
  $options         = undef,
  $parameters      = undef,
  $nameservers     = undef,
  $pxeserver       = undef,
  $domain_name     = undef,
  $static_routes   = undef,
  $search_domains  = undef,
) {

  concat::fragment { "dhcp.conf+70_${name}.dhcp":
    target  => "${::dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.pool.erb'),
    order   => "70-${name}",
  }

}
