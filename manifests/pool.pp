define dhcp::pool (
  String $network,
  String $mask,
  Optional[String] $gateway = undef,
  Variant[Array[String], Optional[String]] $pool_parameters = undef,
  Variant[Array[Dhcp::Range], Optional[Dhcp::Range], Enum[''], Boolean] $range = undef,
  Optional[String] $failover = undef,
  Variant[Array[String], Optional[String]] $options = undef,
  Variant[Array[String], Optional[String]] $parameters = undef,
  Optional[Integer[0]] $mtu = undef,
  Variant[Array[String], Optional[String]] $nameservers = undef,
  Optional[String] $pxeserver = undef,
  Optional[String] $pxefilename = undef,
  Optional[String] $domain_name = undef,
  Optional[Array[Dhcp::StaticRoute]] $static_routes = undef,
  Variant[Array[String], Optional[String]] $search_domains = undef,
  Optional[String] $raw_append = undef,
  Optional[String] $raw_prepend = undef,
) {

  concat::fragment { "dhcp.conf+70_${name}.dhcp":
    target  => "${::dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.pool.erb'),
    order   => "70-${name}",
  }

}
