require 'spec_helper_acceptance'

describe 'Installation with include statement' do
  interface = 'eth0'

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-EOS
      $interface = $facts['networking']['interfaces']['#{interface}']

      file { '/etc/dhcp.include':
        ensure => file,
      }

      class { 'dhcp':
        interfaces => ['#{interface}'],
        includes   => '/etc/dhcp.include',
      }

      dhcp::pool { "default subnet":
        network => $interface['network'],
        mask    => $interface['netmask'],
      }
      EOS
    end
  end

  it_behaves_like 'a DHCP server'
end
