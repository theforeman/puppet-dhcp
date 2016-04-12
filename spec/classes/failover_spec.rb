require 'spec_helper'

describe 'dhcp::failover' do
  context 'supported operating systems' do
    ['Debian', 'RedHat', 'FreeBSD'].each do |osfamily|
      conf_path = (osfamily == 'FreeBSD') ? '/usr/local/etc' : '/etc/dhcp'
      describe "dhcp::failover class on #{osfamily}" do
        let(:pre_condition) {
          "class { '::dhcp': interfaces => ['eth0']}"
        }

        let(:params) do {
          :role         => 'primary',
          :peer_address => '10.1.1.20',
        } end

        let(:facts) do {
          :concat_basedir         => '/doesnotexist',
          :domain                 => 'example.org',
          :osfamily               => osfamily,
          :operatingsystemrelease => '7',
        } end

        it { should compile.with_all_deps }

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+10_failover.dhcp', [
            'failover peer "dhcp-failover" {',
            '  primary;',
            '  address ;',
            '  port 519;',
            '  peer address 10.1.1.20;',
            '  peer port 519;',
            '  max-response-delay 30;',
            '  max-unacked-updates 10;',
            '  load balance max seconds 3;',
            '  mclt 300;', '  split 128;',
            '}'
          ])
        }
      end
    end
  end
end
