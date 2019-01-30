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
define dhcp::host (
  String $ip,
  Dhcp::Macaddress $mac,
  Optional[String] $comment=undef,
) {

  $host = $name

  concat::fragment { "dhcp.hosts+10_${name}.hosts":
    target  => "${dhcp::dhcp_dir}/dhcpd.hosts",
    content => template('dhcp/dhcpd.host.erb'),
    order   => "10-${name}",
  }
}
