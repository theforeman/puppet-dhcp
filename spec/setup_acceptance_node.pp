if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] != 'Fedora' {
  package { 'epel-release':
    ensure => installed,
  }
}

# Needed for the ss command in testing and not included in the base container
if $facts['os']['name'] == 'Fedora' {
  package { 'iproute':
    ensure => installed,
  }
}
