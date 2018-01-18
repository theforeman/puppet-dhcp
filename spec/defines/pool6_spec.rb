require 'spec_helper'

describe 'dhcp::pool6' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :title do 'mypool6' end

      let :facts do
        facts
      end

      let :pre_condition do
        "class { '::dhcp::dhcp6': }"
      end

      describe 'minimal parameters' do
        let :params do {
          :network => '3ffe:501:ffff::',
          :prefix  => 64,
        } end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.conf+70_mypool6.dhcp', [
            "subnet6 3ffe:501:ffff::/64 {",
            "}",
          ])
        }
      end

      describe 'with empty string range' do
        let :params do {
          :network => '3ffe:501:ffff::',
          :prefix  => 64,
          :range   => '',
        } end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.conf+70_mypool6.dhcp', [
            "subnet6 3ffe:501:ffff::/64 {",
            "}",
          ])
        }
      end

      describe 'with range array' do
        let :params do {
          :network => '3ffe:501:ffff::',
          :prefix  => 64,
          :range   => ['3ffe:501:ffff::10 3ffe:501:ffff::20','3ffe:501:ffff::30 3ffe:501:ffff::40'],
        } end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.conf+70_mypool6.dhcp', [
            'subnet6 3ffe:501:ffff::/64 {',
            '  range6 3ffe:501:ffff::10 3ffe:501:ffff::20;',
            '  range6 3ffe:501:ffff::30 3ffe:501:ffff::40;',
            '}',
          ])
        }
      end

      describe 'with search_domains string' do
        let :params do {
          :network        => '3ffe:501:ffff::',
          :prefix         => 64,
          :search_domains => 'example.org, other.example.org'
        } end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.conf+70_mypool6.dhcp', [
            'subnet6 3ffe:501:ffff::/64 {',
            '  option dhcp6.domain-search "example.org", "other.example.org";',
            '}',
          ])
        }
      end

      describe 'full parameters' do
        let :params do {
          :network          => '3ffe:501:ffff::',
          :prefix           => 64,
          :range            => '3ffe:501:ffff::10 3ffe:501:ffff::20',
          :parameters       => 'preferred-lifetime 604800',
          :nameservers      => ['3ffe:501:ffff::2', '3ffe:501:ffff::3'],
          :domain_name      => 'example.org',
          :search_domains   => ['example.org', 'other.example.org'],
          :raw_append       => 'example append;',
          :raw_prepend      => 'example prepend;',
        } end

        it {
          verify_concat_fragment_exact_contents(catalogue, 'dhcp6.conf+70_mypool6.dhcp', [
            "subnet6 3ffe:501:ffff::/64 {",
            "  example prepend;",
            "  range6 3ffe:501:ffff::10 3ffe:501:ffff::20;",
            "  option dhcp6.domain-name \"example.org\";",
            "  preferred-lifetime 604800;",
            "  option dhcp6.name-servers 3ffe:501:ffff::2, 3ffe:501:ffff::3;",
            "  option dhcp6.domain-search \"example.org\", \"other.example.org\";",
            "  example append;",
            "}",
          ])
        }
      end
    end
  end
end
