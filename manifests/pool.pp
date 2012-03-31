define dhcp::pool (
    $network,
    $mask,
    $range,
    $gateway
  ) {

    include dhcp::params

    $dhcp_dir = $dhcp::params::dhcp_dir

    concat::fragment { "dhcp_pool_${name}":
            target  => "${dhcp_dir}/dhcpd.conf",
            content => template("dhcp/dhcpd.pool.erb"),
            order   => 70,
    }
}

