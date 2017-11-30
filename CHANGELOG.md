# Changelog

## 4.1.0

* Make the OMAPI algorithm configurable
* Drop EOL operating systems and add new ones to metadata.json

## 4.0.2
* Fix listen on interfaces in EL7
* Add validation for the DHCP range

## 4.0.1
* Validate parameters using Puppet 4 types

## 4.0.0
* Drop Puppet 3 support
* Add `$omapi`, so OMAPI can be turned off
* Add `$bootp`, so BOOTP can be turned off
* Improve failover logic

## 3.1.0
* Add `$ddns_updates` parameter to allow insecure DDNS updates.
* Add `$pxefilename` parameter to `dhcp::pool`.
* Add `$raw_prepend` and `$raw_append` parameters to `dhcp::pool`.
* Fix classless static routes.

## 3.0.0
* Add bootfiles parameter with hash of client architectures to boot
  loaders used for "filename", defaulting to "pxelinux.0" (#14920)
* Add mtu parameter to main class and to dhcp::pool
* Add Arch Linux support
* Drop support for Ruby 1.8.7
* Many improvements to tests

## 2.3.2
* Fix metadata to show Puppet 4 compatibility
* Remove hashes around pool names for Webmin compatibility

## 2.3.1
* Fix domain-search syntax for multiple search domains (#70)
* Update FreeBSD package name for ISC DHCP 4.3

## 2.3.0
* Add dhcp::failover class to configure DHCP failover between servers
* Add includes parameter to include other config files
* Handle and ignore an empty omapi_key parameter
* Add tests for dhcp::dhcp_class
* Support Puppet 3.0 minimum
* Support Fedora 21, remove Debian 6 (Squeeze)

## 2.2.0
* Add pools, hosts parameters to dhcp to automatically create dhcp::pool
  and dhcp::host resources, usable from Hiera and Foreman
* Add ddns_domainname and ddns_rev_domainname parameters to dhcp
* Add ntpservers parameter to dhcp
* Permit the dhcp::pool range parameter to be an array of ranges

## 2.1.0
* Support configuration on FreeBSD
* Add options parameter for arbitrary options
* Add dhcp::class define to add new DHCP class definitions
* Add pool_parameters param to dhcp::pool for allow statements etc.
* Add authoritative parameter
* Add search_domains parameter to dhcp::pool
* Add omapi_name/omapi_key parameters

## 2.0.0
* Add parameters to dhcp and dhcp:pool to configure static routes
* Change theforeman-concat_native to puppetlabs-concat
* Fix quoting of domain-name option
* Test with future parser and Puppet 4

## 1.6.0
* Add `parameters`, `options` parameters to dhcp::pool
* Add `default_lease_time`, `max_lease_time` parameters to dhcp
* Use longer ISC defaults for lease times
* Minimising differences to puppetlabs/dhcp for eventual merger
* Do not set domain-name option if dnsdomain parameter is empty
* Strip pool config values before checking if they should be set
* Removing unused code, tidyups, better test coverage, increased linting

## 1.5.0
* Add nameservers parameter to dhcp::pool
* Fix config output when empty pool range is passed

## 1.4.0
* Add pxeserver parameter to dhcp::pool
* Unsetting pxeserver/pxefilename disables PXE in a subnet
* Add tests, fix lint and style issues

## 1.3.1
* Change Debian package name to prevent reinstallation on each run
* Fix puppet-lint issues
