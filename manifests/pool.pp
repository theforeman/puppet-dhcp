define dhcp::pool (
    $network,
    $mask,
    $range = false,
    $gateway = false
  ) {

    include dhcp::params

    $dhcp_dir = $dhcp::params::dhcp_dir

    concat_fragment { "dhcp.conf+70_${name}.dhcp":
      content => template('dhcp/dhcpd.pool.erb'),
    }

}

