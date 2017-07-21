class dhcp::failover (
  String $peer_address,
  Enum['primary', 'secondary'] $role = 'primary',
  String $address = $::ipaddress,
  Variant[Integer[0, 65535], String] $port = 519,
  Variant[Integer[0], String] $max_response_delay = 30,
  Variant[Integer[0], String] $max_unacked_updates = 10,
  Variant[Integer[0], String] $mclt = 300,
  Variant[Integer[0], String] $load_split = 128,
  Variant[Integer[0], String] $load_balance = 3,
  Optional[String] $omapi_key = undef,
) {

  include ::dhcp

  concat::fragment { 'dhcp.conf+10_failover.dhcp':
    target  => "${::dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.conf.failover.erb'),
    order   => '10',
  }
}
