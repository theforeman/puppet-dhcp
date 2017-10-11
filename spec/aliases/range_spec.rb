require 'spec_helper'

describe 'test_module::range', type: :class do
  describe 'valid handling' do
    [
      '192.0.2.100',
      '192.0.2.100 192.0.2.200',
      '1.1.1.1 255.255.255.255',
      'dynamic-bootp 192.0.2.100 192.0.2.200',
    ].each do |value|
      describe value.inspect do
        let(:params) {{ value: value }}
        it { is_expected.to compile }
      end
    end
  end

  describe 'invalid value handling' do
    context 'garbage inputs' do
      [
        nil,
        "all",
        "all all",
        "1 192.0.2.183",
        "192.0.2.100 1",
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Dhcp::Range/) }
        end
      end
    end

  end
end
