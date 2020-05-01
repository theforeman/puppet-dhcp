require 'spec_helper_acceptance'

describe 'Installation with include statement' do
  interface = 'eth0'

  let(:pp) do
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

  it_behaves_like 'a idempotent resource'
  it_behaves_like 'a DHCP server'
end
