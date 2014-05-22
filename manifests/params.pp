class dhcp::params {

  $dnsdomain = [$::domain]

  $dhcp_dir = $::osfamily ? {
    'RedHat' => '/etc/dhcp',
    'Debian' => '/etc/dhcp',
    'darwin' => '/opt/local/etc/dhcp',
    default  => '/etc/dhcp',
  }

  $packagename = $::osfamily ? {
    'RedHat' => 'dhcp',
    'Debian' => 'isc-dhcp-server',
    'darwin' => 'dhcp',
    default  => 'dhcp',
  }

  $servicename = $::osfamily ? {
    'RedHat' => 'dhcpd',
    'Debian' => 'isc-dhcp-server',
    'darwin' => 'org.macports.dhcpd',
    default  => 'dhcpd',
  }

}
