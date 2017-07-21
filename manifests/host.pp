define dhcp::host (
  String $ip,
  Dhcp::Macaddress $mac,
  Optional[String] $comment=undef,
) {

  $host = $name

  concat::fragment { "dhcp.hosts+10_${name}.hosts":
    target  => "${::dhcp::dhcp_dir}/dhcpd.hosts",
    content => template('dhcp/dhcpd.host.erb'),
    order   => "10-${name}",
  }
}
