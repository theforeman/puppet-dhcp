require 'spec_helper'

describe 'dhcp::host6' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :title do 'myhost6' end

      describe 'minimal parameters' do
        let :params do {
          :ip  => '3ffe:501:ffff::1',
          :mac => '01:02:03:04:05:06',
        } end

        let :facts do
          facts
        end

        let :pre_condition do
          "class { '::dhcp': interfaces => ['eth0']}"
        end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.hosts+10_myhost6.hosts', [
            'host myhost6 {',
            '  hardware ethernet   01:02:03:04:05:06;',
            '  fixed-address6      3ffe:501:ffff::1;',
            '}',
          ])
        }
      end
    end
  end
end
