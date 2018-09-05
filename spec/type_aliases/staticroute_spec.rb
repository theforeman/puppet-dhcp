require 'spec_helper'

describe 'Dhcp::Staticroute' do
  it do
    is_expected.to allow_values(
      {
        'mask' => '255.255.255.0',
        'gateway' => '192.0.2.1',
      },
      {
        'mask' => '255.255.255.0',
        'gateway' => '192.0.2.1',
        'network' => '192.0.2.0',
      },
    )
  end

  describe 'invalid value handling' do
    [
      nil,
      {},
      {
        'mask' => '255.255.255.0',
      },
      {
        'gateway' => '192.0.2.1',
      },
    ].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
end
