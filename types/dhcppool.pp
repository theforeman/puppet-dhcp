type Dhcp::DhcpPool = Struct[
  {
    'range'                => Variant[Array[Dhcp::Range], Optional[Dhcp::Range], Enum[''], Boolean],
    Optional['failover']   => Optional[String],
    Optional['parameters'] => Variant[Array[String], Optional[String]],
  }
]
