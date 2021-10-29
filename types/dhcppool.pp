# @summary
#   Define a DHCP pool inside a DHCP configuration block
# @see
#   https://linux.die.net/man/5/dhcpd.conf More information about DHCP pools section "Address Pools"
# @see
#   https://stevendiver.com/2020/02/21/isc-dhcp-failover-configuration/ More information about failover
# @param range
#   The range or ranges to assign IP's from
# @param failover
#   Which peer to failover to
# @param parameters
#   Custom parameters, added verbatim to the pool block
type Dhcp::DhcpPool = Struct[
  {
    'range'                => Optional[Variant[Array[Dhcp::Range], Dhcp::Range, Enum[''], Boolean]],
    Optional['failover']   => Optional[String],
    Optional['parameters'] => Optional[Variant[Array[String], String]],
  }
]
