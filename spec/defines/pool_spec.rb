require 'spec_helper'

describe 'dhcp::pool' do
  let :title do 'mypool' end

  let :facts do {
    :osfamily => 'RedHat',
  } end

  describe 'minimal parameters' do
    let :params do {
      :network => '10.0.0.0',
      :mask    => '255.255.255.0',
    } end

    it {
        content = catalogue.resource('concat_fragment', 'dhcp.conf+70_mypool.dhcp').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
          "subnet 10.0.0.0 netmask 255.255.255.0 {",
          "  option subnet-mask 255.255.255.0;",
          "}",
        ]
    }
  end

  describe 'with empty string range' do
    let :params do {
      :network => '10.0.0.0',
      :mask    => '255.255.255.0',
      :range   => '',
    } end

    it {
        content = catalogue.resource('concat_fragment', 'dhcp.conf+70_mypool.dhcp').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
          "subnet 10.0.0.0 netmask 255.255.255.0 {",
          "  option subnet-mask 255.255.255.0;",
          "}",
        ]
    }
  end

  describe 'full parameters' do
    let :params do {
      :network     => '10.0.0.0',
      :mask        => '255.255.255.0',
      :range       => '10.0.0.10 - 10.0.0.50',
      :gateway     => '10.0.0.1',
      :options     => 'ntp-servers 10.0.0.2',
      :parameters  => 'max-lease-time 300',
      :nameservers => ['10.0.0.2', '10.0.0.4'],
      :pxeserver   => '10.0.0.2',
      :domain_name => 'example.org',
      :static_routes => [ { 'mask' => '24', 'network' => '10.0.1.0', 'gateway' => '10.0.0.2' } ],
    } end

    it {
        content = catalogue.resource('concat_fragment', 'dhcp.conf+70_mypool.dhcp').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
          "subnet 10.0.0.0 netmask 255.255.255.0 {",
          "  pool",
          "  {",
          "    range 10.0.0.10 - 10.0.0.50;",
          "  }",
          "  option domain-name \"example.org\";",
          "  option subnet-mask 255.255.255.0;",
          "  option routers 10.0.0.1;",
          "  option rfc3442-classless-static-routes 24, 10, 0, 1, 0, 10, 0, 0, 2;",
          "  option ms-classless-static-routes  24, 10, 0, 1, 0, 10, 0, 0, 2;",
          "  option ntp-servers 10.0.0.2;",
          "  max-lease-time 300;",
          "  option domain-name-servers 10.0.0.2, 10.0.0.4;",
          "  next-server 10.0.0.2;",
          "}",
        ]
    }
  end
end
