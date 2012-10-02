class dhcp::disable {
  include dhcp::params

  $dhcp_dir    = $dhcp::params::dhcp_dir
  $dnsdomain   = $dhcp::params::dnsdomain
  $nameservers = $dhcp::params::nameservers
  $pxeserver   = $dhcp::params::pxeserver
  $filename    = $dhcp::params::filename
  $logfacility = $dhcp::params::logfacility

  package {
    $dhcp::params::packagename:
      ensure => absent;
  }
  service {
    $dhcp::params::servicename:
      ensure    => stopped,
      enable    => false,
      hasstatus => true,
      require   => Package[$dhcp::params::packagename];
  }

}

