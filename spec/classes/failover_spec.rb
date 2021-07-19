require 'spec_helper'

describe 'dhcp::failover' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:pre_condition) {
        "class { '::dhcp': interfaces => ['eth0']}"
      }

      let(:params) do {
        :role         => 'primary',
        :address      => '10.1.1.10',
        :peer_address => '10.1.1.20',
      } end

      let(:facts) do
        facts
      end

      let(:fragment_name) do
        'dhcp.conf+10_failover.dhcp'
      end

      let(:expected_content) do
        <<~CONTENT
          # failover
          failover peer "dhcp-failover" {
            primary;
            address 10.1.1.10;
            port 519;
            peer address 10.1.1.20;
            peer port 519;
            max-response-delay 30;
            max-unacked-updates 10;
            load balance max seconds 3;
            mclt 300;
            split 128;
          }
        CONTENT
      end

      it { should compile.with_all_deps }

      it do
        is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
      end
    end
  end
end
