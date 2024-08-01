# @summary
#   Define a DHCP subnet
# @param network
#   The network range (without the mask) from where IP's will be served
# @param mask
#   The subnet mask for our network 
# @param pools
#   Specify a pool of addresses that will be treated differently than another pool of addresses,
#   even on the same network segment or subnet.
# @param gateway
#   This option specifies a list of comma-separated IP addresses for routers on the client's subnet.
#   Routers should be listed in order of preference.
# @param options
#   Custom DHCP option statements
#   DHCP option statements always start with the option keyword, followed by an option name, followed by option
#   data. The option names and data formats are described below. It is not necessary to exhaustively specify all
#   DHCP options - only those options which are needed by clients
# @param parameters
#   Custom DHCP parameters
#   Each element is added as a separate line
# @param mtu
#   This option specifies the MTU to use on this interface. The minimum legal value for the MTU is 68. 
# @param nameservers
#   Specifies a list of Domain Name System (STD 13, RFC 1035) name servers available to the client.
#   Servers should be listed in order of preference.
# @param pxeserver
#   This is used to specify the host address of the server from which the initial boot file
#   (specified in the filename statement) is to be loaded. Server-name should be a numeric IP address or a
#   domain name. If no next-server statement applies to a given client, the address 0.0.0.0 is used.
# @param pxefilename
#   This can be used to specify the name of the initial boot file which is to be loaded by a
#   client. The filename should be a filename recognizable to whatever file transfer protocol the client can be
#   expected to use to load the file.
# @param domain_name
#   This option specifies the domain name that client should use when resolving hostnames via the Domain Name
#   System.
# @param static_routes
#   This option specifies a list of static routes that the client should install in its routing cache. If multiple
#   routes to the same destination are specified, they are listed in descending order of priority.
# @param search_domains
#   Specifies a ´search list´ of Domain Names to be used by the client to locate not-fully-qualified domain
#   names. The difference between this option and historic use of the domain-name option
#   for the same ends is that this option is encoded in RFC1035 compressed labels on the wire. For example:
# @param raw_append
#   Partial that is appended to the dhcpd.conf (before the final `}`)
# @param raw_prepend
#   Partial that is prepended to the dhcpd.conf (after the first `{`)
# @param order
#   Fragment order in the dhcpd.conf
define dhcp::subnet (
  Stdlib::IP::Address::Nosubnet $network,
  Stdlib::IP::Address::Nosubnet $mask,
  Array[Dhcp::DhcpPool] $pools,
  Optional[String] $gateway = undef,
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
  Integer[1] $order = 70,
) {
  concat::fragment { "dhcp.conf+${order}_${name}.dhcp":
    target  => "${dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.subnet.erb'),
    order   => "${order}-${name}",
  }
}
