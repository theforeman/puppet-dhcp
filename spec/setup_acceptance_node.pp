if $facts['os']['name'] == 'CentOS' {
  package { 'epel-release':
    ensure => installed,
    before => Package['dhcping'],
  }
}

# Needed for the ss command in testing and not included in the base container
if $facts['os']['name'] == 'Fedora' {
  package { 'iproute':
    ensure => installed,
  }
}

package { 'dhcping':
  ensure => installed,
}
