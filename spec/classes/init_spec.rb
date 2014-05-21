require 'spec_helper'

describe 'dhcp' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "dhcp class without any parameters on #{osfamily}" do
        let(:params) do {
          :interfaces => ['eth0'],
        } end

        let(:facts) do {
          :osfamily => osfamily,
        } end

        it { should compile.with_all_deps }
      end
    end
  end
end
