require 'spec_helper'

describe 'dhcp::dhcp_class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :title do 'vendor-class' end

      let :params do {
        :parameters => [
          'match option vendor-class-identifier',
        ]
      } end

      let :facts do
        facts
      end

      let :pre_condition do
        "class { '::dhcp': interfaces => ['eth0']}"
      end

      let(:fragment_name) do
        'dhcp.conf+50_vendor-class.dhcp'
      end

      let(:expected_content) do
        <<~CONTENT
          #################################
          # class vendor-class
          #################################
          class "vendor-class" {
            match option vendor-class-identifier;
          }

        CONTENT
      end

      it do
        is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
      end
    end
  end
end
