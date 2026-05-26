require 'spec_helper_acceptance'

describe 'Simple installation' do
  interface = 'eth0'
  config_file = fact('os.family') == 'Archlinux' ? '/etc/dhcpd.conf' : '/etc/dhcp/dhcpd.conf'

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-EOS
      $interface = $facts['networking']['interfaces']['#{interface}']

      class { 'dhcp':
        interfaces     => ['#{interface}'],
        shared_networks => {
          'shared' => {
            subnets => {
              $interface['network'] => {
                network => $interface['network'],
                mask => $interface['netmask'],
                pools => [],
              },
              '172.20.0.0' => {
                network => '172.20.0.0',
                mask => '255.255.255.0',
                pools => [],
              }
            }
          }
        },
      }
      EOS
    end
  end

  it_behaves_like 'a DHCP server'

  describe file(config_file) do
    it { is_expected.to be_file }
    its(:content) { should match(/shared-network shared/) }
  end
end
