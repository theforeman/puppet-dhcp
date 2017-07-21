type Dhcp::StaticRoute = Struct[
  {
    'mask'              => String,
    'gateway'           => String,
    Optional['network'] => String,
  }
]
