# DHCP module for Puppet

DHCP module for theforeman. Based on original DHCP module by ZLeslie, thanks
to him for the original work.

Installs and manages a DHCP server.

## Dependencies

* [Puppetlabs Concat module](https://github.com/puppetlabs/puppetlabs-concat)

## Features
* Multiple subnet support
* Host reservations
* Secure dynamic DNS updates when combined with Bind
* Failover support

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

DHCPD6 can be deployed by defining the following class. Note, class dhcp is required.

    class { 'dhcp::dhcp6':
      dnsdomain    => [
        'dc1.example.net',
        ],
      interfaces   => ['eth0'],
      nameservers  => ['3ffe:501:ffff:100:200:ff:fe00:3f3e'],
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
      gateway => $gw,
      static_routes =>  [ { 'mask' => '32', 'network' => '169.254.169.254', 'gateway' => $ip },
                          { 'mask' => '0',                                  'gateway' => $gw } ],
    }

### dhcp::pool6
An example for defining an ipv6 subnet:

    dhcp::pool6{ 'v6domain.example.net':
      network        => '3ffe:501:ffff::',
      prefix         => 64,
      search_domains => ['domain.example.net'],
      range          => '3ffe:501:ffff::1fff 3ffe:501:ffff::ffff',
    }

### dhcp::host
Create host reservations.

    dhcp::host {
      'server1': mac => "00:50:56:00:00:01", ip => "10.0.1.51";
      'server2': mac => "00:50:56:00:00:02", ip => "10.0.1.52";
      'server3': mac => "00:50:56:00:00:03", ip => "10.0.1.53";
    }

### dhcp::host6
Create ipv6 host reservation

    dhcp::host6 {
      'server1': mac => "00:50:56:00:00:01", ip => "3ffe:501:ffff::51";
      'server2': mac => "00:50:56:00:00:01", ip => "3ffe:501:ffff::52";
      'server3': mac => "00:50:56:00:00:01", ip => "3ffe:501:ffff::53";
    }


## Contributors

Original authors:

* Zach Leslie <zach.leslie@gmail.com>
* Ben Hughes <git@mumble.org.uk>
* Greg Sutcliffe <greg.sutcliffe@gmail.com>

Copyright (c) 2010-2016 Zach Leslie, Ben Hughes, Greg Sutcliffe, Foreman
developers

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
