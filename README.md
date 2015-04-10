# DHCP module for Puppet

DHCP module for theforeman. Based on original DHCP module by ZLeslie, thanks
to him for the original work.

Installs and manages a DHCP server.

## Dependencies

* Native-type Concat module (https://github.com/onyxpoint/pupmod-concat)

## Features
* Multiple subnet support
* Host reservations
* Secure dynamic DNS updates when combined with Bind

## Usage
Define the server and the zones it will be responsible for.

    class { 'dhcp':
      dnsdomain    => [
        'dc1.example.net',
        '1.0.10.in-addr.arpa',
        ],
      nameservers  => ['10.0.1.20'],
      interfaces   => ['eth0'],
      dnsupdatekey => "/etc/bind/keys.d/$ddnskeyname",
      require      => Bind::Key[ $ddnskeyname ],
      pxeserver    => '10.0.1.50',
      pxefilename  => 'pxelinux.0',
    }

### dhcp::pool
Define the pool attributes

    dhcp::pool{ 'ops.dc1.example.net':
      network => '10.0.1.0',
      mask    => '255.255.255.0',
      range   => '10.0.1.100 10.0.1.200',
      gateway => '10.0.1.1',
    }

Override global attributes with pool specific

    dhcp::pool{ 'ops.dc1.example.net':
      network     => '10.0.1.0',
      mask        => '255.255.255.0',
      range       => '10.0.1.100 10.0.1.200',
      gateway     => '10.0.1.1',
      nameservers => ['10.0.1.2', '10.0.2.2'],
      pxeserver   => '10.0.1.2',
    }

For the support of static routes (RFC3442):

    dhcp::pool{ 'ops.dc1.example.net':
      network => '10.0.1.0',
      mask    => '255.255.255.0',
      range   => '10.0.1.100 10.0.1.200',
      gateway => '10.0.1.1',
      static_routes =>  [ { 'mask' => '32', 'network' => '169.254.169.254', 'gateway' => $ip } ],
    }

### dhcp::host
Create host reservations.

    dhcp::host {
      'server1': mac => "00:50:56:00:00:01", ip => "10.0.1.51";
      'server2': mac => "00:50:56:00:00:02", ip => "10.0.1.52";
      'server3': mac => "00:50:56:00:00:03", ip => "10.0.1.53";
    }

## Contributors
Zach Leslie <zach.leslie@gmail.com>
Ben Hughes <git@mumble.org.uk>
Greg Sutcliffe <greg.sutcliffe@gmail.com>
