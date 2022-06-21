# Define a DHCP host reservation
#
# @param ip
#   The IP address in the reservation
#
# @param mac
#   The host's MAC address
#
# @param comment
#   An optional comment for the host
#
# @param raw_append
#   Host configuration to append as-is
#
# @param raw_prepend
#   Host configuration to prepend as-is
define dhcp::host (
  String $ip,
  Dhcp::Macaddress $mac,
  Optional[String] $comment=undef,
  Optional[String] $raw_append = undef,
  Optional[String] $raw_prepend = undef,
) {
  $host = $name

  concat::fragment { "dhcp.hosts+10_${name}.hosts":
    target  => "${dhcp::dhcp_dir}/dhcpd.hosts",
    content => template('dhcp/dhcpd.host.erb'),
    order   => "10-${name}",
  }
}
