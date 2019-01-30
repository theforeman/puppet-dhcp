# Define a DHCP class
#
# @param parameters
#   The parameters for the class definition. When specified as a string, it
#   will be used verbatim with a semi colon at the end. When specified as an
#   array, every string is used and appended with a semi colon.
define dhcp::dhcp_class (
  Variant[Array[String], String] $parameters,
) {
  concat::fragment { "dhcp.conf+50_${name}.dhcp":
    target  => "${dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.class.erb'),
    order   => "50-${name}",
  }
}
