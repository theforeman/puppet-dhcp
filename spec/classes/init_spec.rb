require 'spec_helper'

describe 'dhcp' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        {
          :interfaces => ['eth0'],
        }.merge(overridden_params)
      end

      conf_path = case os
                  when /^FreeBSD/i
                    '/usr/local/etc'
                  when /^Archlinux/i
                    '/etc'
                  else
                    '/etc/dhcp'
                  end
      describe "dhcp class without any parameters on #{os}" do
        let(:overridden_params) do {
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'not authoritative;',
            'ddns-update-style none;',
            'option domain-name "example.com";',
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

        if facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease].to_i >= 7
          it { is_expected.to contain_systemd__dropin_file('interfaces.conf') }
        else
          it { is_expected.not_to contain_systemd__dropin_file('interfaces.conf') }
        end

        if facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease].to_i < 7
          it { is_expected.to contain_file('/etc/sysconfig/dhcpd') }
        else
          it { is_expected.not_to contain_file('/etc/sysconfig/dhcpd') }
        end

        if facts[:osfamily] == 'Debian'
          it { is_expected.to contain_file('/etc/default/isc-dhcp-server') }
        else
          it { is_expected.not_to contain_file('/etc/default/isc-dhcp-server') }
        end

        if ['FreeBSD', 'DragonFly'].include?(facts[:osfamily])
          it { is_expected.to contain_augeas('set listen interfaces') }
        else
          it { is_expected.not_to contain_augeas('set listen interfaces') }
        end
      end

      describe "dhcp class parameters on #{os}" do
        let(:overridden_params) do {
          :dnsupdatekey  => 'mydnsupdatekey',
          :ntpservers    => ['1.1.1.1', '1.1.1.2'],
          :omapi_name    => 'mykeyname',
          :omapi_key     => 'myomapikey',
          :pxeserver     => '10.0.0.5',
          :mtu           => 9000,
          :pxefilename   => 'mypxefilename',
          :ipxe_filename => 'myipxefilename',
          :bootfiles     => {
            '00:00'       => 'pxelinux.0',
            '00:06'       => 'shim.efi',
            '00:07'       => 'shim.efi',
            '00:09'       => 'shim.efi',
          },
          :option_static_route => true,
          :options      => ['provision-url code 224 = text', 'provision-type code 225 = text'],
          :authoritative => true,
          :ddns_domainname => 'example.com',
          :ddns_rev_domainname => 'in-addr.arpa',
          :ddns_update_style => 'standard',
          :includes => ['myinclude1', 'myinclude2'],
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
            'ddns-update-style standard;',
            'update-static-leases on;',
            'use-host-decl-names on;',
            'ddns-domainname "example.com";',
            'ddns-rev-domainname "in-addr.arpa";',
            'include "mydnsupdatekey";',
            'zone example.com. {',
            '  primary 8.8.8.8;',
            '  key rndc-key;',
            '}',
            'option domain-name "example.com";',
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
            'if exists user-class and option user-class = "iPXE" {',
            '  filename "myipxefilename";',
            '} elsif option architecture = 00:00 {',
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
        let(:overridden_params) do {
          :ddns_updates => true,
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'not authoritative;',
            'ddns-updates on;',
            'ddns-update-style interim;',
            'update-static-leases on;',
            'use-host-decl-names on;',
            'zone example.com. {',
            '  primary 8.8.8.8;',
            '}',
            'option domain-name "example.com";',
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
        let(:overridden_params) do {
          :omapi => false,
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'not authoritative;',
            'ddns-update-style none;',
            'option domain-name "example.com";',
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
        let(:overridden_params) do {
          :bootp => false,
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'not authoritative;',
            'ddns-update-style none;',
            'option domain-name "example.com";',
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

      describe "with failover, bootp undef" do
        let(:overridden_params) do {
          :failover => true
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'not authoritative;',
            'ddns-update-style none;',
            'option domain-name "example.com";',
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
        let(:overridden_params) do {
          :failover => true,
          :bootp => true
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'not authoritative;',
            'ddns-update-style none;',
            'option domain-name "example.com";',
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
        let(:overridden_params) do {
          :failover => true,
          :bootp => false
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
            'omapi-port 7911;',
            'default-lease-time 43200;',
            'max-lease-time 86400;',
            'not authoritative;',
            'ddns-update-style none;',
            'option domain-name "example.com";',
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

      describe "with config_comment" do
        context 'with multiple lines' do
          let(:overridden_params) do {
            :config_comment => "first line\nsecond line"
          } end

          it do
            verify_concat_fragment_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
              '# first line',
              '# second line',
            ])
          end
        end
      end
    end
  end
end
