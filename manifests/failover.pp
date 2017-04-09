class dhcp::failover (
  $peer_address,
  $role                = 'primary',
  $address             = $::ipaddress,
  $port                = '519',
  $max_response_delay  = '30',
  $max_unacked_updates = '10',
  $mclt                = '300',
  $load_split          = '128',
  $load_balance        = '3',
  $omapi_key           = undef,
) {

  include ::dhcp

  concat_fragment { 'dhcp.conf+10_failover.dhcp':
    target  => "${::dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.conf.failover.erb'),
    order   => '10',
    tag     => 'concat_file_dhcpd.conf',
  }
}
