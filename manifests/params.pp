class dhcp::params {

  $dhcp_dir = $::operatingsystem ? {
    /redhat,centos,fedora,Scientific/ => '/etc/dhcp',
    /Ubuntu,Debian/                   => '/etc/dhcp',
    darwin                            => '/opt/local/etc/dhcp',
    default                           => '/etc/dhcp',
  }

  $packagename = $::operatingsystem ? {
    /redhat,centos,fedora,Scientific/ => 'dhcp',
    /Ubuntu,Debian/                   => 'dhcp3-server',
    darwin                            => 'dhcp',
    default                           => 'dhcp',
  }

  $servicename = $::operatingsystem ? {
    /redhat,centos,fedora,Scientific/ => 'dhcpd',
    /Ubuntu,Debian/                   => 'isc-dhcp-server',
    darwin                            => 'org.macports.dhcpd',
    default                           => 'dhcpd',
  }

}
