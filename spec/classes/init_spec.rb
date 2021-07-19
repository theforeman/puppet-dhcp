require 'spec_helper'

describe 'dhcp' do
  let(:fragment_name) do
    'dhcp.conf+01_main.dhcp'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { override_facts(facts, networking: {domain: 'example.com'}) }

      let(:params) do
        {
          interfaces: ['eth0'],
        }
      end

      let(:conf_path) do
        case os
        when /^FreeBSD/i
          '/usr/local/etc'
        when /^Archlinux/i
          '/etc'
        else
          '/etc/dhcp'
        end
      end

      describe "without any parameters" do
        let(:expected_content) do
          <<~CONTENT
            # dhcpd.conf
            omapi-port 7911;

            default-lease-time 43200;
            max-lease-time 86400;


            not authoritative;


            ddns-update-style none;

            option domain-name "example.com";
            option ntp-servers none;

            allow booting;
            allow bootp;

            option fqdn.no-client-update    on;  # set the "O" and "S" flag bits
            option fqdn.rcode2            255;
            option pxegrub code 150 = text ;





            log-facility local7;

            include "#{conf_path}/dhcpd.hosts";
          CONTENT
        end

        it { should compile.with_all_deps }

        it do
          is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
        end

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

      describe "with all parameters" do
        let(:params) do
          super().merge(
            :dnsupdatekey  => 'mydnsupdatekey',
            :nameservers   => ['8.8.8.8', '8.8.4.4'],
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
          )
        end

        let(:expected_content) do
          <<~CONTENT
            # dhcpd.conf
            omapi-port 7911;
            key mykeyname {
              algorithm HMAC-MD5;
              secret "myomapikey";
            }
            omapi-key mykeyname;

            default-lease-time 43200;
            max-lease-time 86400;

            # Make the server authoritative for the network segments that
            # are configured, and tell it to send DHCPNAKs to bogus requests
            authoritative;

            ddns-updates on;
            ddns-update-style standard;
            update-static-leases on;
            use-host-decl-names on;

            ddns-domainname "example.com";
            ddns-rev-domainname "in-addr.arpa";

            # Key from bind
            include "mydnsupdatekey";
            zone example.com. {
              primary 8.8.8.8;
              key rndc-key;
            }

            option domain-name "example.com";
            option domain-name-servers 8.8.8.8, 8.8.4.4;
            option ntp-servers 1.1.1.1, 1.1.1.2;

            allow booting;
            allow bootp;

            option fqdn.no-client-update    on;  # set the "O" and "S" flag bits
            option fqdn.rcode2            255;
            option pxegrub code 150 = text ;

            option rfc3442-classless-static-routes code 121 = array of integer 8;
            option ms-classless-static-routes code 249 = array of integer 8;

            option interface-mtu 9000;

            option provision-url code 224 = text;
            option provision-type code 225 = text;

            # required for UEFI HTTP boot
            if substring(option vendor-class-identifier, 0, 10) = "HTTPClient" {
              option vendor-class-identifier "HTTPClient";
            }
            # promote vendor in dhcpd.leases
            set vendor-string = option vendor-class-identifier;
            # next server and filename options
            next-server 10.0.0.5;
            option architecture code 93 = unsigned integer 16 ;
            if exists user-class and option user-class = "iPXE" {
              filename "myipxefilename";
            } elsif option architecture = 00:00 {
              filename "pxelinux.0";
            } elsif option architecture = 00:06 {
              filename "shim.efi";
            } elsif option architecture = 00:07 {
              filename "shim.efi";
            } elsif option architecture = 00:09 {
              filename "shim.efi";
            } else {
              filename "mypxefilename";
            }

            log-facility local7;

            include "#{conf_path}/dhcpd.hosts";
          CONTENT
        end

        it { should compile.with_all_deps }

        it do
          is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
        end

        it do
          is_expected.to contain_concat__fragment('dhcp.conf+20_includes')
            .with_content(<<~CONTENT)
              include "myinclude1";
              include "myinclude2";
            CONTENT
        end
      end

      describe "with ddns-updates without key" do
        let(:params) do
          super().merge(
            ddns_updates: true,
            nameservers: ['8.8.8.8', '8.8.4.4'],
          )
        end

        it { should compile.with_all_deps }

        let(:expected_content) do
          <<~CONTENT
            # dhcpd.conf
            omapi-port 7911;

            default-lease-time 43200;
            max-lease-time 86400;


            not authoritative;

            ddns-updates on;
            ddns-update-style interim;
            update-static-leases on;
            use-host-decl-names on;


            # Key from bind
            zone example.com. {
              primary 8.8.8.8;
            }

            option domain-name "example.com";
            option domain-name-servers 8.8.8.8, 8.8.4.4;
            option ntp-servers none;

            allow booting;
            allow bootp;

            option fqdn.no-client-update    on;  # set the "O" and "S" flag bits
            option fqdn.rcode2            255;
            option pxegrub code 150 = text ;





            log-facility local7;

            include "#{conf_path}/dhcpd.hosts";
          CONTENT
        end

        it do
          is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
        end
      end

      describe "with ddns-updates and client-updates ignored" do
        let(:params) do
          super().merge(
            ddns_updates: true,
            client_updates: false,
            dnsupdateserver: '127.1.2.3',
          )
        end

        let(:expected_content) do
          <<~CONTENT
            # dhcpd.conf
            omapi-port 7911;

            default-lease-time 43200;
            max-lease-time 86400;


            not authoritative;

            ddns-updates on;
            ddns-update-style interim;
            update-static-leases on;
            use-host-decl-names on;
            ignore client-updates;


            # Key from bind
            zone example.com. {
              primary 127.1.2.3;
            }

            option domain-name "example.com";
            option ntp-servers none;

            allow booting;
            allow bootp;

            option fqdn.no-client-update    on;  # set the "O" and "S" flag bits
            option fqdn.rcode2            255;
            option pxegrub code 150 = text ;





            log-facility local7;

            include "#{conf_path}/dhcpd.hosts";
          CONTENT
        end

        it { should compile.with_all_deps }

        it do
          is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
        end
      end

      describe "without omapi" do
        let(:params) { super().merge(omapi: false) }

        let(:expected_content) do
          <<~CONTENT
            # dhcpd.conf

            default-lease-time 43200;
            max-lease-time 86400;


            not authoritative;


            ddns-update-style none;

            option domain-name "example.com";
            option ntp-servers none;

            allow booting;
            allow bootp;

            option fqdn.no-client-update    on;  # set the "O" and "S" flag bits
            option fqdn.rcode2            255;
            option pxegrub code 150 = text ;





            log-facility local7;

            include "#{conf_path}/dhcpd.hosts";
          CONTENT
        end

        it { should compile.with_all_deps }

        it do
          is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
        end
      end

      describe "without bootp" do
        let(:params) { super().merge(bootp: false) }

        it { should compile.with_all_deps }
        it { should contain_concat__fragment('dhcp.conf+01_main.dhcp').without_content(/allow bootp/) }
      end

      describe 'with failover' do
        let(:params) { super().merge(failover: true) }

        describe "and bootp undef" do
          let(:expected_content) do
            <<~CONTENT
              # dhcpd.conf
              omapi-port 7911;

              default-lease-time 43200;
              max-lease-time 86400;


              not authoritative;


              ddns-update-style none;

              option domain-name "example.com";
              option ntp-servers none;

              allow booting;

              option fqdn.no-client-update    on;  # set the "O" and "S" flag bits
              option fqdn.rcode2            255;
              option pxegrub code 150 = text ;





              log-facility local7;

              include "#{conf_path}/dhcpd.hosts";
            CONTENT
          end

          it { should compile.with_all_deps }

          it do
            is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
          end
        end

        describe "and bootp true" do
          let(:params) { super().merge(bootp: true) }

          let(:expected_content) do
            <<~CONTENT
              # dhcpd.conf
              omapi-port 7911;

              default-lease-time 43200;
              max-lease-time 86400;


              not authoritative;


              ddns-update-style none;

              option domain-name "example.com";
              option ntp-servers none;

              allow booting;
              allow bootp;

              option fqdn.no-client-update    on;  # set the "O" and "S" flag bits
              option fqdn.rcode2            255;
              option pxegrub code 150 = text ;





              log-facility local7;

              include "#{conf_path}/dhcpd.hosts";
            CONTENT
          end

          it { should compile.with_all_deps }

          it do
            is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
          end
        end

        describe "and bootp false" do
          let(:params) { super().merge(bootp: false) }

          let(:expected_content) do
            <<~CONTENT
              # dhcpd.conf
              omapi-port 7911;

              default-lease-time 43200;
              max-lease-time 86400;


              not authoritative;


              ddns-update-style none;

              option domain-name "example.com";
              option ntp-servers none;

              allow booting;

              option fqdn.no-client-update    on;  # set the "O" and "S" flag bits
              option fqdn.rcode2            255;
              option pxegrub code 150 = text ;





              log-facility local7;

              include "#{conf_path}/dhcpd.hosts";
            CONTENT
          end

          it { should compile.with_all_deps }

          it do
            is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
          end
        end
      end

      describe "with config_comment" do
        context 'with multiple lines' do
          let(:params) { super().merge(config_comment: "first line\nsecond line") }

          it do
            verify_concat_fragment_contents(catalogue, 'dhcp.conf+01_main.dhcp', [
              '# first line',
              '# second line',
            ])
          end
        end
      end

      describe "with config_comment" do
        context 'with multiple lines' do
          let(:params) { super().merge(ddns_updates: true) }
          it { is_expected.to compile.and_raise_error(%r{dnsupdateserver or nameservers parameter is required to enable ddns}) }
        end
      end
    end
  end
end
