# Changelog

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
