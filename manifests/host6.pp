#class dhcp::host6
define dhcp::host6 (
  String $ip,
  Dhcp::Macaddress $mac,
  Optional[String] $comment=undef,
) {

  $host = $name

  concat::fragment { "dhcp6.hosts+10_${name}.hosts":
    target  => "${::dhcp::dhcp_dir}/dhcpd6.hosts",
    content => template('dhcp/dhcpd6.host.erb'),
    order   => "10-${name}",
  }
}
