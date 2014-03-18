class dhcp (
    $dnsdomain,
    $nameservers,
    $interfaces     = undef,
    $interface      = 'NOTSET',
    $dnskeyname     = 'rndc-key',
    $dnsupdatekey   = undef,
    $pxeserver      = undef,
    $pxefilename    = undef,
    $logfacility    = 'local7',
    $dhcp_monitor   = true,
    $omapiport      = undef,
    $omapialgorithm = undef,
    $omapisecret    = undef
) {

  include dhcp::params

  $dhcp_dir    = $dhcp::params::dhcp_dir
  $packagename = $dhcp::params::packagename
  $servicename = $dhcp::params::servicename

  # Incase people set interface instead of interfaces work around
  # that. If they set both, use interfaces and the user is a unwise
  # and deserves what they get.
  if $interface != 'NOTSET' and $interfaces == undef {
    $dhcp_interfaces = [ $interface ]
  } elsif $interface == 'NOTSET' and $interfaces == undef {
    fail ("You need to set \$interfaces in ${module_name}")
  } else {
    $dhcp_interfaces = $interfaces
  }

  package {
    $packagename:
      ensure   => installed,
      provider => $::operatingsystem ? {
        default => undef,
        darwin  => macports
      }
  }

  file {
      $dhcp_dir:
          mode    => '0755',
          require => Package[$packagename],
  }

  # Only debian and ubuntu have this style of defaults for startup.
  case $::operatingsystem {
    'debian','ubuntu': {
      file{ '/etc/default/isc-dhcp-server':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        before  => Package[$packagename],
        notify  => Service[$servicename],
        content => template('dhcp/debian/default_isc-dhcp-server'),
      }
    }
    'redhat','centos','fedora','Scientific': {
      file{ '/etc/sysconfig/dhcpd':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        before  => Package[$packagename],
        notify  => Service[$servicename],
        content => template('dhcp/redhat/sysconfig-dhcpd'),
      }
    }
  }

  concat_build { 'dhcp.conf':
    order   => ['*.dhcp'],
    require => Package[$packagename],
    notify  => [Service[$servicename],File["${dhcp_dir}/dhcpd.conf"]],
  }
  file { "${dhcp_dir}/dhcpd.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => concat_output('dhcp.conf'),
    require => [Package[$packagename],Concat_build['dhcp.conf']],
  }

  concat_fragment { 'dhcp.conf+01_main.dhcp':
    content => template('dhcp/dhcpd.conf.erb'),
  }

  concat_build { 'dhcp.hosts':
    order   => ['*.hosts'],
    require => Package[$packagename],
    notify  => [Service[$servicename],File["${dhcp_dir}/dhcpd.hosts"]],
  }
  file { "${dhcp_dir}/dhcpd.hosts":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => concat_output('dhcp.hosts'),
    require => [Package[$packagename],Concat_build['dhcp.hosts']],
  }

  concat_fragment { 'dhcp.hosts+01_main.hosts':
    content => "# static DHCP hosts\n",
  }

  service {
    $servicename:
      ensure    => running,
      enable    => true,
      hasstatus => true,
      subscribe => File["${dhcp_dir}/dhcpd.hosts", "${dhcp_dir}/dhcpd.conf"],
      require   => Package[$packagename],
  }

}
