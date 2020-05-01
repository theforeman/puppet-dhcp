shared_examples 'a DHCP server' do
  service_name = case fact('osfamily')
                 when 'Debian'
                   'isc-dhcp-server'
                 else
                   'dhcpd'
                 end
  describe service(service_name) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(67) do
    it { is_expected.to be_listening.on('0.0.0.0').with('udp') }
  end
end
