require 'spec_helper'

describe 'dhcp::host' do
  let :title do 'myhost' end

  describe 'minimal parameters' do
    let :params do {
      :ip  => '10.0.0.100',
      :mac => '01:02:03:04:05:06',
    } end

    it {
      content = catalogue.resource('concat_fragment', 'dhcp.hosts+10_myhost.hosts').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
        'host myhost {',
        '  hardware ethernet   01:02:03:04:05:06;',
        '  fixed-address       10.0.0.100;',
        '  ddns-hostname       "myhost";',
        '}',
      ]
    }
  end
end
