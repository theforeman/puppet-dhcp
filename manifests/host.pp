# Define a DHCP host reservation
#
# @param ip
#   The IP address in the reservation
#
# @param mac
#   The host's MAC address
#
# @param family
#   Whether this is for DHCPv4 or for DHCPv6
#
# @param comment
#   An optional comment for the host
define dhcp::host (
  String $ip,
  Dhcp::Macaddress $mac,
  Enum['v4', 'v6'] $family = 'v4',
  Optional[String] $comment=undef,
) {

  $host = $name

  if $family == 'v4' {
    concat::fragment { "dhcp.hosts+10_${name}.hosts":
      target  => "${dhcp::dhcp_dir}/dhcpd.hosts",
      content => template('dhcp/dhcpd.host.erb'),
      order   => "10-${name}",
    }
  } elsif $family == 'v6' {
    concat::fragment { "dhcp6.hosts+10_${name}.hosts":
      target  => "${dhcp::dhcp_dir}/dhcpd6.hosts",
      content => template('dhcp/dhcpd6.host.erb'),
      order   => "10-${name}",
    }
  }
}
