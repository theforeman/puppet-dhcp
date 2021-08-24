# Define a DHCP pool
#
# For v6, currently only the following parameters are implemented, all others will be ignored:
#   * network (required)
#   * range
#   * pool_parameters
#   * options
#   * parameters
#   * nameservers
#   * domain_name (doesn't exist in DHCPv6, but we'll use it as fallback for undef search_domains)
#   * search_domains
#   * raw_append
#   * raw_prepend
#
# What about the other parameters?
# The following parameters should be configured via Router Advertisements (take a look at radvd)
#   * gateway
#   * mtu
#   * static_routes
#
define dhcp::pool (
  String $network,
  Enum['v4', 'v6'] $family = 'v4',
  Optional[String] $mask = undef,
  Optional[String] $gateway = undef,
  Variant[Array[String], Optional[String]] $pool_parameters = undef,
  Variant[Array[String], Optional[String], Boolean] $range = undef,
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

  if $family == 'v4' {

    if $mask == undef { fail('Must specify $mask for DHCPv4!') }
    if !($range =~ Variant[Array[Dhcp::Range], Optional[Dhcp::Range], Enum[''], Boolean]) {
      fail("Invalid value '${range}' for parameter \$range!")
    }

    concat::fragment { "dhcp.conf+70_${name}.dhcp":
      target  => "${dhcp::dhcp_dir}/dhcpd.conf",
      content => template('dhcp/dhcpd.pool.erb'),
      order   => "70-${name}",
    }

  } elsif $family == 'v6' {

    concat::fragment { "dhcp6.conf+70_${name}.dhcp6":
      target  => "${dhcp::dhcp_dir}/dhcpd6.conf",
      content => template('dhcp/dhcpd6.pool.erb'),
      order   => "70-${name}",
    }

  }

}
