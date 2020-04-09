# Default parameters
# @api private
class dhcp::params {

  $dnsdomain = $facts['os']['family'] ? {
    'Archlinux' => [$facts['domain']], # lint:ignore:legacy_facts
    default     => [$facts['networking']['domain']],
  }

  $pxefilename = 'pxelinux.0'

  case $facts['os']['family'] {
    'Debian': {
      $dhcp_dir    = '/etc/dhcp'
      $packagename = 'isc-dhcp-server'
      $servicename = 'isc-dhcp-server'
      $root_group  = 'root'
      $bootfiles   = {
        '00:06' => 'grub2/bootia32.efi',
        '00:07' => 'grub2/bootx64.efi',
        '00:09' => 'grub2/bootx64.efi',
      }
    }

    /^(FreeBSD|DragonFly)$/: {
      $dhcp_dir    = '/usr/local/etc'
      $packagename = 'isc-dhcp44-server'
      $servicename = 'isc-dhcpd'
      $root_group  = 'wheel'
      $bootfiles   = {}
    }

    'Archlinux': {
      $dhcp_dir    = '/etc'
      $packagename = 'dhcp'
      $servicename = 'dhcpd4'
      $root_group  = 'root'
      $bootfiles   = {}
    }

    'RedHat': {
      $dhcp_dir    = '/etc/dhcp'
      $packagename = 'dhcp'
      $servicename = 'dhcpd'
      $root_group  = 'root'
      if $facts['os']['release']['full'] =~ /^[0-6]\./ {
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
      fail("${facts['networking']['hostname']}: This module does not support osfamily ${facts['os']['family']}")
    }
  }
}
