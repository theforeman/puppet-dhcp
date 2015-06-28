require 'spec_helper'

describe 'dhcp::host' do
  let :title do 'myhost' end

  describe 'minimal parameters' do
    let :params do {
      :ip  => '10.0.0.100',
      :mac => '01:02:03:04:05:06',
    } end

    let :facts do {
      :concat_basedir => '/doesnotexist',
    } end

    it {
      verify_concat_fragment_exact_contents(catalogue, 'dhcp.hosts+10_myhost.hosts', [
        'host myhost {',
        '  hardware ethernet   01:02:03:04:05:06;',
        '  fixed-address       10.0.0.100;',
        '  ddns-hostname       "myhost";',
        '}',
      ])
    }
  end
end
