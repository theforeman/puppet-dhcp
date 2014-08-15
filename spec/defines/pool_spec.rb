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
        content = subject.resource('concat_fragment', 'dhcp.conf+70_mypool.dhcp').send(:parameters)[:content]
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
      :pxeserver   => '10.0.0.2',
      :domain_name => 'example.com',
    } end

    it {
        content = subject.resource('concat_fragment', 'dhcp.conf+70_mypool.dhcp').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
          "subnet 10.0.0.0 netmask 255.255.255.0 {",
          "  pool",
          "  {",
          "    range 10.0.0.10 - 10.0.0.50;",
          "  }",
          '  option domain-name 'example.com';',
          "  option subnet-mask 255.255.255.0;",
          "  option routers 10.0.0.1;",
          "  next-server 10.0.0.2;",
          "}",
        ]
    }
  end
end
