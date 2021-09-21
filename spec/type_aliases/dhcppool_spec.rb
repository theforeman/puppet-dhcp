require 'spec_helper'

describe 'Dhcp::DhcpPool' do
  it do
    is_expected.to allow_values(
      {
        'range' => '10.0.0.100 10.0.0.200',
      },
      {
        'range' => true,
      },
      {
        'range' => [
          '10.0.0.100 10.0.0.200',
          '10.1.0.100 10.1.0.200',
        ],
        'failover' => 'dhcp-failover',
        'parameters' => 'omapi-port 7911',
      },
      {
        'range' => '',
        'parameters' => [
          'omapi-key primaryhost',
          'omapi-port 7911',
        ],
      },
    )
  end

  describe 'invalid value handling' do
    [
      nil,
      {
        'range' => 5,
      },
      {
        'failover' => true,
      },
    ].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
end
