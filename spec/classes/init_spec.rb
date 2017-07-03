require 'spec_helper'

describe 'dhcp' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      conf_path = case os
                  when /^FreeBSD/i
                    '/usr/local/etc'
                  when /^Archlinux/i
                    '/etc'
                  else
                    '/etc/dhcp'
                  end

      let(:node) { 'foo.example.org' }

      describe "dhcp class without any parameters on #{os}" do
        let(:params) do {
          :interfaces => ['eth0'],
        } end

        let(:facts) do
          facts.merge({
            :concat_basedir => '/doesnotexist',
            :domain         => 'example.org',
          })
        end

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

        it { is_expected.not_to contain_concat__fragment('dhcp.conf+20_includes') }
      end

      describe "dhcp class parameters on #{os}" do
        let(:params) do {
          :interfaces   => ['eth0'],
          :dnsupdatekey => 'mydnsupdatekey',
          :ntpservers   => ['1.1.1.1', '1.1.1.2'],
          :omapi_name   => 'mykeyname',
          :omapi_key    => 'myomapikey',
          :pxeserver    => '10.0.0.5',
          :mtu          => 9000,
          :pxefilename  => 'mypxefilename',
          :bootfiles    => {
            '00:00'       => 'pxelinux.0',
            '00:06'       => 'shim.efi',
            '00:07'       => 'shim.efi',
            '00:09'       => 'shim.efi',
          },
          :option_static_route => true,
          :options      => ['provision-url code 224 = text', 'provision-type code 225 = text'],
          :authoritative => true,
          :ddns_domainname => 'example.org',
          :ddns_rev_domainname => 'in-addr.arpa',
          :includes => ['myinclude1', 'myinclude2'],
        } end

        let(:facts) do
          facts.merge({
            :concat_basedir => '/doesnotexist',
            :domain         => 'example.org',
          })
        end

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
            'option interface-mtu 9000;',
            'option provision-url code 224 = text;',
            'option provision-type code 225 = text;',
            'next-server 10.0.0.5;',
            'option architecture code 93 = unsigned integer 16 ;',
            'if option architecture = 00:00 {',
            '  filename "pxelinux.0";',
            '} elsif option architecture = 00:06 {',
            '  filename "shim.efi";',
            '} elsif option architecture = 00:07 {',
            '  filename "shim.efi";',
            '} elsif option architecture = 00:09 {',
            '  filename "shim.efi";',
            '} else {',
            '  filename "mypxefilename";',
            '}',
            'log-facility local7;',
            "include \"#{conf_path}/dhcpd.hosts\";",
          ])
        }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+20_includes', [
            'include "myinclude1";',
            'include "myinclude2";',
          ])
        }
      end

      describe "ddns-updates without key" do
        let(:params) do {
          :interfaces => ['eth0'],
          :ddns_updates => true,
        } end

        let(:facts) do
          facts.merge({:domain => 'example.org'})
        end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'ddns-updates on;',
            'ddns-update-style interim;',
            'update-static-leases on;',
            'use-host-decl-names on;',
            'zone example.org. {',
            '  primary 8.8.8.8;',
            '}',
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

      describe "without omapi" do
        let(:params) do {
          :interfaces => ['eth0'],
          :omapi => false,
        } end

        let(:facts) do
          facts.merge({
            :concat_basedir => '/doesnotexist',
            :domain         => 'example.org',
          })
        end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
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

      describe "without bootp" do
        let(:params) do {
          :interfaces => ['eth0'],
          :bootp => false,
        } end

        let(:facts) do
          facts.merge({
            :concat_basedir => '/doesnotexist',
            :domain         => 'example.org',
          })
        end

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
            'option fqdn.no-client-update    on;  # set the "O" and "S" flag bits',
            'option fqdn.rcode2            255;',
            'option pxegrub code 150 = text ;',
            'log-facility local7;',
            "include \"#{conf_path}/dhcpd.hosts\";",
          ])
        }
      end
      describe "without failover, bootp undef" do
        let(:params) do {
          :interfaces => ['eth0'],
        } end

        let(:facts) do
          facts.merge({
            :concat_basedir => '/doesnotexist',
            :domain         => 'example.org',
          })
        end

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
      describe "with failover, bootp undef" do
        let(:params) do {
          :interfaces => ['eth0'],
          :failover => true
        } end

        let(:facts) do
          facts.merge({
            :concat_basedir => '/doesnotexist',
            :domain         => 'example.org',
          })
        end

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
            'option fqdn.no-client-update    on;  # set the "O" and "S" flag bits',
            'option fqdn.rcode2            255;',
            'option pxegrub code 150 = text ;',
            'log-facility local7;',
            "include \"#{conf_path}/dhcpd.hosts\";",
          ])
        }
      end
      describe "with failover, bootp true" do
        let(:params) do {
          :interfaces => ['eth0'],
          :failover => true,
          :bootp => true
        } end

        let(:facts) do
          facts.merge({
            :concat_basedir => '/doesnotexist',
            :domain         => 'example.org',
          })
        end

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
      describe "with failover, bootp false" do
        let(:params) do {
          :interfaces => ['eth0'],
          :failover => true,
          :bootp => false
        } end

        let(:facts) do
          facts.merge({
            :concat_basedir => '/doesnotexist',
            :domain         => 'example.org',
          })
        end

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
            'option fqdn.no-client-update    on;  # set the "O" and "S" flag bits',
            'option fqdn.rcode2            255;',
            'option pxegrub code 150 = text ;',
            'log-facility local7;',
            "include \"#{conf_path}/dhcpd.hosts\";",
          ])
        }
      end
    end
  end
end
