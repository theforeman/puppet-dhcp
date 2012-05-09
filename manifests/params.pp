class dhcp::params {

    $dhcp_dir = $operatingsystem ? {
        debian  => "/etc/dhcp",
        ubuntu  => "/etc/dhcp3",
        darwin  => "/opt/local/etc/dhcp",
        default => "/etc",
    }

    $packagename = $operatingsystem ? {
      darwin  => "dhcp",
      Ubuntu  => "dhcp3-server",
      default => "isc-dhcp-server",
    }

    $servicename = $operatingsystem ? {
      darwin  => "org.macports.dhcpd",
      Ubuntu  => "dhcp3-server",
      default => "isc-dhcp-server",
    }

}
