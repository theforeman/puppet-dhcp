# class dhcp::pool6
define dhcp::pool6 (
  String $network,
  Integer[0] $prefix,
  Variant[Array[String], Optional[String]] $pool_parameters = undef,
  Variant[Array[Dhcp::Range6], String, Optional[Dhcp::Range6], Enum[''], Boolean] $range = undef,
  Optional[String] $failover = undef,
  Variant[Array[String], Optional[String]] $options = undef,
  Variant[Array[String], Optional[String]] $parameters = undef,
  Optional[Integer[0]] $mtu = undef,
  Variant[Array[String], Optional[String]] $nameservers = undef,
  Optional[String] $pxeserver = undef,
  Optional[String] $pxefilename = undef,
  Optional[String] $domain_name = undef,
  Variant[Array[String], Optional[String]] $search_domains = undef,
  Optional[String] $raw_append = undef,
  Optional[String] $raw_prepend = undef,
) {

  concat::fragment { "dhcp6.conf+70_${name}.dhcp":
    target  => "${::dhcp::dhcp6::dhcp_dir}/${::dhcp::dhcp6::dhcp_conf6}.conf",
    content => template('dhcp/dhcpd6.pool.erb'),
    order   => "70-${name}",
  }

}
