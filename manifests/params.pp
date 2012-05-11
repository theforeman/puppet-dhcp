class dhcp::params {

  $dhcp_dir = $operatingsystem ? {
    Ubuntu,debian => "/etc/dhcp",
    darwin        => "/opt/local/etc/dhcp",
    default       => "/etc",
  }

  $packagename = $operatingsystem ? {
    Ubuntu,Ubuntu => "dhcp3-server",
    darwin        => "dhcp",
    default       => "isc-dhcp-server",
  }

  $servicename = $operatingsystem ? {
    darwin        => "org.macports.dhcpd",
    Ubuntu,Debian => "isc-dhcp-server",
    default       => "isc-dhcp-server",
  }

}
