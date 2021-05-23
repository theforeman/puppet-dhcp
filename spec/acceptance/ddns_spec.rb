require 'spec_helper_acceptance'

describe 'Simple installation' do
  interface = 'eth0'

  let(:pp) do
    <<-EOS
    $interface = $facts['networking']['interfaces']['#{interface}']

    class { 'dhcp':
      interfaces   => ['#{interface}'],
      ddns_updates => true,
    }

    dhcp::pool { "default subnet":
      network => $interface['network'],
      mask    => $interface['netmask'],
    }
    EOS
  end

  it 'blows up' do
    result = apply_manifest(pp, expect_failures: true)
    expect(result.exit_code).to eq 1
    expect(result.stderr).to match(%r{dnsupdateserver or nameservers parameter is required to enable ddns})
  end
end
