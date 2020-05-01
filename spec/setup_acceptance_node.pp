if $facts['os']['name'] == 'CentOS' {
  package { 'epel-release':
    ensure => installed,
    before => Package['dhcping'],
  }
}

package { 'dhcping':
  ensure => installed,
}
