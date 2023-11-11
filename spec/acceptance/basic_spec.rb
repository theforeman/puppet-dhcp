require 'spec_helper_acceptance'

describe 'Simple installation' do
  interface = 'eth0'
  config_file = fact('os.family') == 'Archlinux' ? '/etc/dhcpd.conf' : '/etc/dhcp/dhcpd.conf'

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-EOS
      $interface = $facts['networking']['interfaces']['#{interface}']

      class { 'dhcp':
        interfaces => ['#{interface}'],
      }

      dhcp::pool { "default subnet":
        network => $interface['network'],
        mask    => $interface['netmask'],
      }

      dhcp::host { $facts['networking']['fqdn']:
        ip  => $interface['ip'],
        mac => $interface['mac'],
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
