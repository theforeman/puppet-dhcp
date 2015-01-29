require 'spec_helper'

describe 'dhcp::pools' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      describe 'with no parameters' do
        it { should compile.with_all_deps }

        it { should have_dhcp__pool_resource_count(0) }
      end

      describe 'with pools' do
        let(:params) do {
          :pools => {"pool_one"=>{"network"=>"192.168.1.0",
                                  "mask"=>"255.255.255.0",
                                  "range"=>"192.168.1.20 192.168.1.250",
                                  "gateway"=>"192.168.1.1",
                                  "nameservers"=>["8.8.8.8", "8.8.4.4"],
                                  "pxeserver"=>"192.168.1.2"},
                     "pool_two"=>{"network"=>"192.168.2.0",
                                  "mask"=>"255.255.255.0"}}
        } end

        it { should compile.with_all_deps }

        it do
          should have_dhcp__pool_resource_count(2)

          should contain_dhcp__pool('pool_one').with(
            "network"=>"192.168.1.0",
            "mask"=>"255.255.255.0",
            "range"=>"192.168.1.20 192.168.1.250",
            "gateway"=>"192.168.1.1",
            "nameservers"=>["8.8.8.8", "8.8.4.4"],
            "pxeserver"=>"192.168.1.2")

          should contain_dhcp__pool('pool_two').with(
            "network"=>"192.168.2.0",
            "mask"=>"255.255.255.0")
        end
      end

      describe 'with defaults and pools' do
        let(:params) do {
          :pools => {"pool_one"=>{"network"=>"192.168.1.0",
                                  "mask"=>"255.255.255.0",
                                  "range"=>"192.168.1.20 192.168.1.250",
                                  "gateway"=>"192.168.1.1"},
                     "pool_two"=>{"network"=>"192.168.2.0",
                                  "mask"=>"255.255.255.0"}},
          :defaults => {"nameservers"=>["8.8.8.8", "8.8.4.4"],
                        "pxeserver"=>"192.168.1.2"},
        } end

        it { should compile.with_all_deps }

        it do
          should have_dhcp__pool_resource_count(2)

          should contain_dhcp__pool('pool_one').with(
            "nameservers"=>["8.8.8.8", "8.8.4.4"],
            "pxeserver"=>"192.168.1.2")

          should contain_dhcp__pool('pool_two').with(
            "nameservers"=>["8.8.8.8", "8.8.4.4"],
            "pxeserver"=>"192.168.1.2")
        end
      end
    end
  end
end
