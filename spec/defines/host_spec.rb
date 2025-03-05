require 'spec_helper'

describe 'dhcp::host' do
  let :title do 'myhost' end

  let :params do {
    :ip  => '10.0.0.100',
    :mac => '01:02:03:04:05:06',
  } end

  let :pre_condition do
    "class { '::dhcp': interfaces => ['eth0']}"
  end

  let(:fragment_name) do
    'dhcp.hosts+10_myhost.hosts'
  end

  shared_examples "a concat template" do
    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_concat__fragment(fragment_name).with_content(expected_content)
    end
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      describe 'minimal parameters' do
        let(:expected_content) do
          <<~CONTENT
            host myhost {
              hardware ethernet   01:02:03:04:05:06;
              fixed-address       10.0.0.100;
              ddns-hostname       "myhost";
            }
          CONTENT
        end

        it_behaves_like "a concat template"
      end

      describe 'comment parameter' do
        let(:params) { super().merge(comment: 'a useful comment') }

        let(:expected_content) do
          <<~CONTENT
            # a useful comment
            host myhost {
              hardware ethernet   01:02:03:04:05:06;
              fixed-address       10.0.0.100;
              ddns-hostname       "myhost";
            }
          CONTENT
        end

        it_behaves_like "a concat template"
      end

      describe 'raw_prepend parameter' do
        let(:params) { super().merge(raw_prepend: 'fixed-address6 FE80:0000:0000:0000:903A:1C1A:E802:11E4;') }

        let(:expected_content) do
          <<~CONTENT
            host myhost {
              fixed-address6 FE80:0000:0000:0000:903A:1C1A:E802:11E4;
              hardware ethernet   01:02:03:04:05:06;
              fixed-address       10.0.0.100;
              ddns-hostname       "myhost";
            }
          CONTENT
        end

        it_behaves_like "a concat template"
      end

      describe 'raw_append parameter' do
        let(:params) { super().merge(raw_append: 'dhcp-client-identifier "spec";') }

        let(:expected_content) do
          <<~CONTENT
            host myhost {
              hardware ethernet   01:02:03:04:05:06;
              fixed-address       10.0.0.100;
              ddns-hostname       "myhost";
              dhcp-client-identifier "spec";
            }
          CONTENT
        end

        it_behaves_like "a concat template"
      end
    end
  end
end
