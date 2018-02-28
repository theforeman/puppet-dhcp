# class dhcp::dhcp6
class dhcp::dhcp6 (
  Array[String] $nameservers = ['2001:4860:4860::8888', '2001:4860:4860::8844'],
  Optional[Array[String]] $interfaces = undef,
  String $interface = 'NOTSET',
  Integer[0] $default_lease_time6 = 2592000,
  Integer[0] $default_preferred_lifetime6 = 604800,
  Integer[0] $default_renewal_time6 = 3600,
  Integer[0] $default_rebinding_time6 = 7200,
  Integer[0] $default_info_refresh_time6 = 21600,
  Boolean $leasequery6 = true,
  Boolean $rapid_commit6 = false,
  Integer[0] $default_preference6 = 10,
  Stdlib::Absolutepath $dhcp_dir = $dhcp::params::dhcp_dir,
  String $packagename = $dhcp::params::packagename,
  String $servicename6 = $dhcp::params::servicename6,
  Boolean $supportv6 = $dhcp::params::supportv6,
  Variant[Array[String], Optional[String]] $options = undef,
  String $dhcp_root_group = $dhcp::params::root_group,
  Hash[String, Hash] $pools6 = {},
  Hash[String, Hash] $hosts6 = {},
  Variant[Array[String], Optional[String]] $includes = undef,
) inherits dhcp::params {

  if ! defined(Package[$packagename]){
    package { $packagename:
      ensure   => installed,
    }
  }

  if ! $::operatingsystemmajrelease {
    warning("${::operatingsystem} ${::operatingsystemmajrelease} ${servicename6} does not support dhcpv6")
  } else {

    # In case people set interface instead of interfaces work around
    # that. If they set both, use interfaces and the user is a unwise
    # and deserves what they get.
    if $interface != 'NOTSET' and $interfaces == undef {
      $dhcp6_interfaces = [ $interface ]
    } elsif $interface == 'NOTSET' and $interfaces == undef {
      fail ("You need to set \$interfaces in ${module_name}")
    } else {
      $dhcp6_interfaces = $interfaces
    }

    if ! defined(Class['dhcp']){
      # Only debian and ubuntu have this style of defaults for startup.
      case $::osfamily {
        'Debian': {
          concat{ '/etc/default/isc-dhcp-server':
            owner  => 'root',
            group  => 'root',
            mode   => '0644',
            before => Package[$packagename],
            notify => Service[$servicename6],
          }
        }
        'RedHat': {
          if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
            include ::systemd
            systemd::dropin_file { 'interfaces.conf':
              unit    => 'dhcpd.service',
              content => template('dhcp/redhat/systemd-dropin.conf.erb'),
            }
          } else {
            file { '/etc/sysconfig/dhcpd':
              ensure  => file,
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              before  => Package[$packagename],
              notify  => Service[$servicename6],
              content => template('dhcp/redhat/sysconfig-dhcpd'),
            }
          }
        }
        /^(FreeBSD|DragonFly)$/: {
          $interfaces_line = join($dhcp6_interfaces, ' ')
          augeas { 'set listen interfaces':
            context => '/files/etc/rc.conf',
            changes => "set dhcpd_ifaces '\"${interfaces_line}\"'",
            before  => Package[$packagename],
            notify  => Service[$servicename6],
          }
        }
        default: {
        }
      }
    }

    concat::fragment { 'isc-dhcp-server.dhcp6':
      target  => '/etc/default/isc-dhcp-server',
      content => template('dhcp/debian/default_isc-dhcp-server6'),
      order   => '02',
    }

    concat { "${dhcp_dir}/dhcpd6.conf":
      owner   => 'root',
      group   => $dhcp_root_group,
      mode    => '0644',
      require => Package[$packagename],
      notify  => Service[$servicename6],
    }

    concat::fragment { 'dhcp6.conf+01_main.dhcp':
      target  => "${dhcp_dir}/dhcpd6.conf",
      content => template('dhcp/dhcpd6.conf.erb'),
      order   => '01',
    }

    if $includes {
      concat::fragment { 'dhcp6.conf+20_includes':
        target  => "${dhcp_dir}/dhcpd6.conf",
        content => template('dhcp/dhcpd6.conf.includes.erb'),
        order   => '20',
      }
    }

    concat { "${dhcp_dir}/dhcpd6.hosts":
      owner   => 'root',
      group   => $dhcp_root_group,
      mode    => '0644',
      require => Package[$packagename],
      notify  => Service[$servicename6],
    }

    concat::fragment { 'dhcp6.hosts+01_main.hosts':
      target  => "${dhcp_dir}/dhcpd6.hosts",
      content => "# static DHCP hosts\n",
      order   => '01',
    }

    create_resources('dhcp::pool6', $pools6)
    create_resources('dhcp::host6', $hosts6)

    if ! defined(Service[$servicename6]){
      service { $servicename6:
        ensure => running,
        enable => true,
      }
    }
  }

}
