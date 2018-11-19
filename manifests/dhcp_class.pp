define dhcp::dhcp_class (
  Variant[Array[String], String] $parameters,
) {
  concat::fragment { "dhcp.conf+50_${name}.dhcp":
    target  => "${dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.class.erb'),
    order   => "50-${name}",
  }
}
