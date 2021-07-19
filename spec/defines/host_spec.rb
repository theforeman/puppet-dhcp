require 'spec_helper'

describe 'dhcp::host' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :title do 'myhost' end

      describe 'minimal parameters' do
        let :params do {
          :ip  => '10.0.0.100',
          :mac => '01:02:03:04:05:06',
        } end

        let :facts do
          facts
        end

        let :pre_condition do
          "class { '::dhcp': interfaces => ['eth0']}"
        end

        let(:fragment_name) do
          'dhcp.hosts+10_myhost.hosts'
        end

        let(:expected_content) do
          <<~CONTENT
            host myhost {
              hardware ethernet   01:02:03:04:05:06;
              fixed-address       10.0.0.100;
              ddns-hostname       "myhost";
            }
          CONTENT
        end

        it do
          is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
        end
      end
    end
  end
end
