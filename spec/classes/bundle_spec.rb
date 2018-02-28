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

    end
  end
end
