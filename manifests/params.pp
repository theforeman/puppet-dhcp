class dhcp::params {

    $dhcp_dir = $operatingsystem ? {
        debian  => "/etc/dhcp",
        ubuntu  => "/etc/dhcp",
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
      Ubuntu  => "isc-dhcp-server",
      default => "isc-dhcp-server",
    }

}
