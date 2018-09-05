require 'spec_helper'

describe 'Dhcp::Range' do
  it do
    is_expected.to allow_values(
      '192.0.2.100',
      '192.0.2.100 192.0.2.200',
      '1.1.1.1 255.255.255.255',
      'dynamic-bootp 192.0.2.100 192.0.2.200',
    )
  end

  describe 'invalid value handling' do
    [
      nil,
      "all",
      "all all",
      "1 192.0.2.183",
      "192.0.2.100 1",
    ].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
end
