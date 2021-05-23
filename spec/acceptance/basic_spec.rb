require 'spec_helper_acceptance'

describe 'Simple installation' do
  interface = 'eth0'

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

      dhcp::host { $facts['fqdn']:
        ip  => $interface['ip'],
        mac => $interface['mac'],
      }
      EOS
    end
  end

  it_behaves_like 'a DHCP server'

  describe file('/etc/dhcp/dhcpd.conf') do
    its(:content) { is_expected.not_to match %r{option domain-name-servers } }
  end

  ip = fact("networking.interfaces.#{interface}.ip")
  mac = fact("networking.interfaces.#{interface}.mac")

  describe command("dhcping -c #{ip} -h #{mac} -s #{ip}") do
    its(:stdout) do
      pending('This is broken in docker containers')
      is_expected.to match("Got answer from: #{ip}")
    end
  end
end
