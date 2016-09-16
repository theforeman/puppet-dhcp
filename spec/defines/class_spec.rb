require 'spec_helper'

describe 'dhcp::dhcp_class' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let :title do 'vendor-class' end

        let :params do {
          :parameters => [
            'match option vendor-class-identifier',
          ]
        } end

        let :facts do
          facts.merge({
            :concat_basedir => '/doesnotexist',
          })
        end

        let :pre_condition do
          "class { '::dhcp': interfaces => ['eth0']}"
        end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+50_vendor-class.dhcp', [
            'class "vendor-class" {',
            '  match option vendor-class-identifier;',
            '}'
          ])
        }
      end
    end
  end
end
