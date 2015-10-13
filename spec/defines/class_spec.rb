require 'spec_helper'

describe 'dhcp::dhcp_class' do
  let :title do 'vendor-class' end

  let :params do {
    :parameters => [
      'match option vendor-class-identifier',
    ]
  } end

  let :facts do {
    :concat_basedir => '/doesnotexist',
  } end

  it {
    verify_concat_fragment_exact_contents(catalogue, 'dhcp.conf+50_vendor-class.dhcp', [
      'class "vendor-class" {',
      '  match option vendor-class-identifier;',
      '}'
    ])
  }
end
