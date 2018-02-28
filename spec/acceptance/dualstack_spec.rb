require 'spec_helper_acceptance'

describe 'Simple installation' do
  before(:context) do

    if fact('ipaddress6') == false
      exit(0)
    end

    if fact('osfamily') == 'RedHat'
      on default, puppet('resource package epel-release ensure=present')
    end
    on default, puppet('resource package dhcping ensure=present')
  end

  interface = 'eth0'

  supportv6 = case fact("networking.interfaces.#{interface}.ip6")
                when /.*::.*/
                  case fact('osfamily')
                    when 'Debian'
                      if fact('operatingsystemmajrelease') == '8'
                        false
                      else
                        true
                      end
                    else
                      true
                    end
                else
                  false
                end

  service_name = case fact('osfamily')
                 when 'Debian'
                   'isc-dhcp-server'
                 else
                   'dhcpd'
                 end

  service_name6 = case fact('osfamily')
                 when 'Debian'
                   'isc-dhcp-server'
                 else
                   'dhcpd6'
                 end

  if supportv6 == true
    let(:pp) do
      <<-EOS
      $interface = $::facts['networking']['interfaces'][#{interface}]

      class { '::dhcp':
        interfaces => ['#{interface}'],
      }

      ::dhcp::pool { 'default-subnet':
        network => $interface['network'],
        mask    => $interface['netmask'],
      }

      ::dhcp::host { $::fqdn:
        ip  => $interface['ip'],
        mac => $interface['mac'],
      }

      class { 'dhcp::dhcp6':
        interfaces => ['#{interface}'],
      }

      ::dhcp::pool6 { 'default-v6-subnet':
        network => $interface['network6'],
        prefix  => 64,
      }

      ::dhcp::host6 { 'v6-host':
        ip  => $interface['ip6'],
        mac => $interface['mac'],
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

    ip = fact("networking.interfaces.#{interface}.ip")
    mac = fact("networking.interfaces.#{interface}.mac")

    describe command("dhcping -c #{ip} -h #{mac} -s #{ip}") do
      its(:stdout) {
        pending('This is broken in docker containers')
        is_expected.to match("Got answer from: #{ip}")
      }
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

end
