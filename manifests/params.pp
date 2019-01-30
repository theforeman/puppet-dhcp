# Default parameters
# @api private
class dhcp::params {

  $dnsdomain = [$facts['domain']]
  $pxefilename = 'pxelinux.0'

  case $facts['osfamily'] {
    'Debian': {
      $dhcp_dir     = '/etc/dhcp'
      $packagename  = 'isc-dhcp-server'
      $servicename  = 'isc-dhcp-server'
      $servicename6 = 'isc-dhcp-server'
      $root_group   = 'root'
      $bootfiles    = {
        '00:06' => 'grub2/bootia32.efi',
        '00:07' => 'grub2/bootx64.efi',
        '00:09' => 'grub2/bootx64.efi',
      }
      case $::operatingsystemrelease {
        '8': {
          $supportv6 = false
        }
        default: {
          $supportv6 = true
        }
      }
    }

    /^(FreeBSD|DragonFly)$/: {
      $dhcp_dir     = '/usr/local/etc'
      $packagename  = 'isc-dhcp43-server'
      $servicename  = 'isc-dhcpd'
      $servicename6 = 'isc-dhcpd'
      $root_group   = 'wheel'
      $supportv6    = false
      $bootfiles    = {}
    }

    'Archlinux': {
      $dhcp_dir     = '/etc'
      $packagename  = 'dhcp'
      $servicename  = 'dhcpd4'
      $servicename6 = 'dhcpd6'
      $root_group   = 'root'
      $supportv6    = true
      $bootfiles    = {}
    }

    'RedHat': {
      $dhcp_dir     = '/etc/dhcp'
      $packagename  = 'dhcp'
      $servicename  = 'dhcpd'
      $servicename6 = 'dhcpd6'
      $root_group   = 'root'
      $supportv6    = true
      if $facts['operatingsystemrelease'] =~ /^[0-6]\./ {
        $bootfiles = {
          '00:07' => 'grub/grubx64.efi',
          '00:09' => 'grub/grubx64.efi',
        }
      } else {
        $bootfiles = {
          '00:06' => 'grub2/shim.efi',
          '00:07' => 'grub2/shim.efi',
          '00:09' => 'grub2/shim.efi',
        }
      }
    }

    default: {
      fail("${facts['hostname']}: This module does not support osfamily ${facts['osfamily']}")
    }
  }
}
