define dhcp::host (
  $ip,
  $mac,
  $comment=''
) {

  $host = $name

  concat_fragment { "dhcp.hosts+10_${name}.hosts":
    content => template('dhcp/dhcpd.host.erb'),
  }
}
