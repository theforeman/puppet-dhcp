require 'spec_helper_acceptance'

describe 'with empty nameservers list' do
  interface = 'eth0'
  config_file = fact('osfamily') == 'Archlinux' ? '/etc/dhcpd.conf' : '/etc/dhcp/dhcpd.conf'

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

  ip = fact("networking.interfaces.#{interface}.ip")
  mac = fact("networking.interfaces.#{interface}.mac")

  describe command("dhcping -c #{ip} -h #{mac} -s #{ip}") do
    its(:stdout) {
      pending('This is broken in docker containers')
      is_expected.to match("Got answer from: #{ip}")
    }
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

  ip = fact("networking.interfaces.#{interface}.ip")
  mac = fact("networking.interfaces.#{interface}.mac")

  describe command("dhcping -c #{ip} -h #{mac} -s #{ip}") do
    its(:stdout) {
      pending('This is broken in docker containers')
      is_expected.to match("Got answer from: #{ip}")
    }
  end
end
