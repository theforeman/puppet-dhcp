# == Class: dhcp::pools
#
# Generate a number of DHCP pools using a hash of data
#
# === Parameters
#
# $pools::    Hash of DHCP pools to be instantiated
#             type:hash
#
# $defaults:: Default properties and values for all pools
#             type:hash
#
class dhcp::pools (
  $pools = {},
  $defaults = {},
) {
  validate_hash($pools)
  validate_hash($defaults)

  create_resources('dhcp::pool', $pools, $defaults)
}
