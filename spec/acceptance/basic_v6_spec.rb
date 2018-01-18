require 'spec_helper_acceptance'

describe 'Simple installation' do
  before(:context) do
    if fact('osfamily') == 'RedHat'
      on default, puppet('resource package epel-release ensure=present')
    end
    on default, puppet('resource package dhcping ensure=present')
  end

  interface = 'eth0'
  service_name6 = case fact('osfamily')
                 when 'Debian'
                   'isc-dhcp-server'
                 else
                   'dhcpd6'
                 end

  let(:pp) do
    <<-EOS
    $interface = $::facts['networking']['interfaces'][#{interface}]

    class { 'dhcp::dhcp6': }

    ::dhcp::pool6 { 'default-v6-subnet':
      network => $interface['network6'],
      prefix  => 64,
    }

    ::dhcp::host6 { 'v6-host':
      ip => $interface['ip6'],
      mac => $interface['mac'],
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe service(service_name6) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(547) do
    it { is_expected.to be_listening.with('udp6') }
  end

  ip6 = fact("networking.interfaces.#{interface}.ip6")
  mac = fact("networking.interfaces.#{interface}.mac")

  describe command("dhcping -c #{ip6} -h #{mac} -s #{ip6}") do
    its(:stdout) {
      pending('This is broken in docker containers')
      is_expected.to match("Got answer from: #{ip6}")
    }
  end
end
