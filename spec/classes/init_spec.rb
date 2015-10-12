require 'spec_helper'

describe 'dhcp' do
  context 'supported operating systems' do
    ['Debian', 'RedHat', 'FreeBSD'].each do |osfamily|
      conf_path = (osfamily == 'FreeBSD') ? '/usr/local/etc' : '/etc/dhcp'
      describe "dhcp class without any parameters on #{osfamily}" do
        let(:params) do {
          :interfaces => ['eth0'],
        } end

        let(:facts) do {
          :concat_basedir => '/doesnotexist',
          :domain         => 'example.org',
          :osfamily       => osfamily,
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'ddns-update-style none;',
            'option domain-name "example.org";',
            'option domain-name-servers 8.8.8.8, 8.8.4.4;',
            "option ntp-servers none;",
            'allow booting;',
            'allow bootp;',
            'option fqdn.no-client-update    on;  # set the "O" and "S" flag bits',
            'option fqdn.rcode2            255;',
            'option pxegrub code 150 = text ;',
            'log-facility local7;',
            "include \"#{conf_path}/dhcpd.hosts\";",
          ])
        }
      end

      describe "dhcp class parameters on #{osfamily}" do
        let(:params) do {
          :interfaces   => ['eth0'],
          :dnsupdatekey => 'mydnsupdatekey',
          :ntpservers   => ['1.1.1.1', '1.1.1.2'],
          :omapi_name	=> 'mykeyname',
          :omapi_key	=> 'myomapikey',
          :pxeserver    => '10.0.0.5',
          :pxefilename  => 'mypxefilename',
          :option_static_route => true,
          :options      => ['provision-url code 224 = text', 'provision-type code 225 = text'],
          :authoritative => true,
          :ddns_domainname => 'example.org',
          :ddns_rev_domainname => 'in-addr.arpa',
        } end

        let(:facts) do {
          :concat_basedir => '/doesnotexist',
          :domain         => 'example.org',
          :osfamily       => osfamily,
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'key mykeyname {',
            '  algorithm HMAC-MD5;',
            '  secret "myomapikey";',
            '}',
            'omapi-key mykeyname;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'authoritative;',
            'ddns-updates on;',
            'ddns-update-style interim;',
            'update-static-leases on;',
            'use-host-decl-names on;',
	    'ddns-domainname "example.org";',
	    'ddns-rev-domainname "in-addr.arpa";',
            'include "mydnsupdatekey";',
            'zone example.org. {',
            '  primary 8.8.8.8;',
            '  key rndc-key;',
            '}',
            'option domain-name "example.org";',
            'option domain-name-servers 8.8.8.8, 8.8.4.4;',
            'option ntp-servers 1.1.1.1, 1.1.1.2;',
            'allow booting;',
            'allow bootp;',
            'option fqdn.no-client-update    on;  # set the "O" and "S" flag bits',
            'option fqdn.rcode2            255;',
            'option pxegrub code 150 = text ;',
            'option rfc3442-classless-static-routes code 121 = array of integer 8;',
            'option ms-classless-static-routes code 249 = array of integer 8;',
            'option provision-url code 224 = text;',
            'option provision-type code 225 = text;',
            'next-server 10.0.0.5;',
            'filename "mypxefilename";',
            'log-facility local7;',
            "include \"#{conf_path}/dhcpd.hosts\";",
          ])
        }
      end
    end
  end
end
