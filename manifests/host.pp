define dhcp::host (
  $ip,
  $mac,
  $comment=undef,
) {

  $host = $name

  concat::fragment { "dhcp.hosts+10_${name}.hosts":
    target  => "${::dhcp::dhcp_dir}/dhcpd.hosts",
    content => template('dhcp/dhcpd.host.erb'),
    order   => "10-${name}",
  }
}
