# Define a failover peer
#
# @param peer_address
#   The address of the failover peer.
#
# @param role
#   Primary or Secondary role in DHCP failover relationship.
#
# @param address
#   IP Address of the DHCP failover server.
#
# @param port
#   Port to listen for failover messages.
#
# @param max_response_delay
#   max-response-delay in seconds before failover peer is considered failed.
#
# @param max_unacked_updated
#   max-unacked-updates before the server will wait to send additional packets to peer.
#
# @param mclt
#   MCLT, the maximum time a lease may be extended beyond expiration set by DHCP peer.
#
# @param load_split
#   Load split between the DHCP servers as fraction out of 256.
#
# @param load_balance
#   Load balance max seconds, cutoff after which load balancing is disabled.
#
# @param omapi_key
#   OMAPI key to cryptographically sign traffic if OMAPI protocol is enabled.
class dhcp::failover (
  String $peer_address,
  Enum['primary', 'secondary'] $role = 'primary',
  String $address = $facts['networking']['ip'],
  Variant[Integer[0, 65535], String] $port = 519,
  Variant[Integer[0], String] $max_response_delay = 30,
  Variant[Integer[0], String] $max_unacked_updates = 10,
  Variant[Integer[0], String] $mclt = 300,
  Variant[Integer[0], String] $load_split = 128,
  Variant[Integer[0], String] $load_balance = 3,
  Optional[String] $omapi_key = undef,
) {

  include dhcp

  concat::fragment { 'dhcp.conf+10_failover.dhcp':
    target  => "${dhcp::dhcp_dir}/dhcpd.conf",
    content => template('dhcp/dhcpd.conf.failover.erb'),
    order   => '10',
  }
}
