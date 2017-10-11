require 'spec_helper'

describe 'test_module::staticroute', type: :class do
  describe 'valid handling' do
    [
      {
        'mask' => '255.255.255.0',
        'gateway' => '192.0.2.1',
      },
      {
        'mask' => '255.255.255.0',
        'gateway' => '192.0.2.1',
        'network' => '192.0.2.0',
      },
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
        {},
        {
          'mask' => '255.255.255.0',
        },
        {
          'gateway' => '192.0.2.1',
        },
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects/) }
        end
      end
    end

  end
end
