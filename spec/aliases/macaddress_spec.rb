require 'spec_helper'

describe 'test_module::macaddress', type: :class do
  describe 'valid handling' do
    [
      'a:a:a:a:a:a',
      '00:00:00:00:00:00',
      '11:11:11:11:11:11',
      '22:22:22:22:22:22',
      '33:33:33:33:33:33',
      '44:44:44:44:44:44',
      '55:55:55:55:55:55',
      '66:66:66:66:66:66',
      '77:77:77:77:77:77',
      '88:88:88:88:88:88',
      '99:99:99:99:99:99',
      'aa:aa:aa:aa:aa:aa',
      'bb:bb:bb:bb:bb:bb',
      'cc:cc:cc:cc:cc:cc',
      'dd:dd:dd:dd:dd:dd',
      'ee:ee:ee:ee:ee:ee',
      'ff:ff:ff:ff:ff:ff',
      'AA:AA:AA:AA:AA:AA',
      'BB:BB:BB:BB:BB:BB',
      'CC:CC:CC:CC:CC:CC',
      'DD:DD:DD:DD:DD:DD',
      'EE:EE:EE:EE:EE:EE',
      'FF:FF:FF:FF:FF:FF',
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
        "aa:aa:aa:aa:aa",
        "aaa:aa:aa:aa:aa:aa",
        "aa:aaa:aa:aa:aa:aa",
        "aa:aa:aaa:aa:aa:aa",
        "aa:aa:aa:aaa:aa:aa",
        "aa:aa:aa:aa:aaa:aa",
        "aa:aa:aa:aa:aa:aaa",
        "aa:aa:aa:aa:aa:aa:aa",
        "gg:gg:gg:gg:gg:gg",
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Dhcp::Macaddress/) }
        end
      end
    end

  end
end
