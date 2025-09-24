# @summary
#   Define a DHCP shared-network
# @param subnets
#   subnets to include in the shared-network statement
# @param order
#   Fragment order in the dhcpd.conf
define dhcp::sharednet (
  Hash[String,Hash] $subnets = {},
  Integer[1] $order = 75,
) {
  concat::fragment { "dhcp.conf+${order}-start_${name}.dhcp":
    target  => "${dhcp::dhcp_dir}/dhcpd.conf",
    content => "shared-network ${name} {\n",
    order   => "${order}-0start",
  }
  concat::fragment { "dhcp.conf+${order}-end_${name}.dhcp":
    target  => "${dhcp::dhcp_dir}/dhcpd.conf",
    content => "}\n",
    order   => "${order}-9end",
  }
  create_resources('dhcp::subnet', $subnets, { order => $order })
}
