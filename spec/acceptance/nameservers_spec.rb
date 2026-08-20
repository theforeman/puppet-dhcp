require 'spec_helper_acceptance'

describe 'with empty nameservers list' do
  interface = 'eth0'
  config_file = fact('os.family') == 'Archlinux' ? '/etc/dhcpd.conf' : '/etc/dhcp/dhcpd.conf'

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-EOS
      $interface = $facts['networking']['interfaces']['#{interface}']

      class { 'dhcp':
        interfaces  => ['#{interface}'],
        nameservers => [],
      }

      dhcp::pool { "default subnet":
        network => $interface['network'],
        mask    => $interface['netmask'],
      }
      EOS
    end
  end

  it_behaves_like 'a DHCP server'

  describe file(config_file) do
    it { is_expected.to be_file }
    its(:content) { should_not match %r{option domain-name-servers } }
  end
end

describe 'with a non-empty nameservers list' do
  interface = 'eth0'
  config_file = fact('osfamily') == 'Archlinux' ? '/etc/dhcpd.conf' : '/etc/dhcp/dhcpd.conf'

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-EOS
      $interface = $facts['networking']['interfaces']['#{interface}']

      class { 'dhcp':
        interfaces  => ['#{interface}'],
        nameservers => ['8.8.8.8', '8.8.4.4'],
      }

      dhcp::pool { "default subnet":
        network => $interface['network'],
        mask    => $interface['netmask'],
      }
      EOS
    end
  end

  it_behaves_like 'a DHCP server'

  describe file(config_file) do
    its(:content) { should match %r{option domain-name-servers 8.8.8.8, 8.8.4.4;} }
  end
end
