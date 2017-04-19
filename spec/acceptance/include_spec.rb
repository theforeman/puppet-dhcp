require 'spec_helper_acceptance'

describe 'Installation with include statement' do
  before(:context) do
    if fact('osfamily') == 'RedHat'
      on default, puppet('resource package epel-release ensure=present')
    end
    on default, puppet('resource package dhcping ensure=present')
  end

  interface = 'eth0'
  service_name = case fact('osfamily')
                 when 'Debian'
                   'isc-dhcp-server'
                 else
                   'dhcpd'
                 end

  let(:pp) do
    <<-EOS
    $interface = $::facts['networking']['interfaces'][#{interface}]

    file { '/etc/dhcp.include':
      ensure => file,
    }

    class { '::dhcp':
      interfaces => ['#{interface}'],
      includes   => '/etc/dhcp.include',
    }

    ::dhcp::pool { "default subnet":
      network => $interface['network'],
      mask    => $interface['netmask'],
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe service(service_name) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(67) do
    it { is_expected.to be_listening.on('0.0.0.0').with('udp') }
  end
end
