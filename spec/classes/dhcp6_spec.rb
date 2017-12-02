require 'spec_helper'

describe 'dhcp::dhcp6' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      conf_path = case os
                  when /^FreeBSD/i
                    '/usr/local/etc'
                  when /^Archlinux/i
                    '/etc'
                  else
                    '/etc/dhcp'
                  end
      describe "dhcp::dhcp6 class without any parameters on #{os}" do

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.conf+01_main.dhcp', [
            'default-lease-time 2592000;',
            'preferred-lifetime 604800;',
            'option dhcp-renewal-time 3600;',
            'option dhcp-rebinding-time 7200;',
            'option dhcp6.info-refresh-time 21600;',
            'allow leasequery;',
            'option dhcp6.preference 10;',
            'option dhcp6.name-servers 2001:4860:4860::8844, 2001:4860:4860::8888;',
            "include \"#{conf_path}/dhcpd6.hosts\";",
          ])
        }

        it { is_expected.not_to contain_concat__fragment('dhcp6.conf+20_includes') }
      end

      describe "dhcp::dhcp6 class test all params on #{os}" do
        let(:params) do {
          :nameservers                 => ['2001:4860:4860::8888','2001:4860:4860::8844'],
          :default_lease_time6         => 2592000,
          :default_preferred_lifetime6 => 604800,
          :default_renewal_time6       => 3600,
          :default_rebinding_time6     => 7200,
          :default_info_refresh_time6  => 21600,
          :leasequery6                 => true,
          :rapid_commit6               => true,
          :default_preference6         => 255,
          :includes                    => ['myinclude1', 'myinclude2'],
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.conf+01_main.dhcp', [
            'default-lease-time 2592000;',
            'preferred-lifetime 604800;',
            'option dhcp-renewal-time 3600;',
            'option dhcp-rebinding-time 7200;',
            'option dhcp6.info-refresh-time 21600;',
            'allow leasequery;',
            'option dhcp6.preference 255;',
            'option dhcp6.rapid-commit;',
            'option dhcp6.name-servers 2001:4860:4860::8844, 2001:4860:4860::8888;',
            "include \"#{conf_path}/dhcpd6.hosts\";",
          ])

          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.conf+20_includes', [
            'include "myinclude1";',
            'include "myinclude2";',
          ])
        }
      end
    end
  end
end
