# Changelog

## [5.0.1](https://github.com/theforeman/puppet-dhcp/tree/5.0.1) (2019-06-12)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/5.0.0...5.0.1)

**Merged pull requests:**

- allow newer puppetlabs-concat version [\#157](https://github.com/theforeman/puppet-dhcp/pull/157) ([mmoll](https://github.com/mmoll))
- Allow `puppetlabs/stdlib` 6.x [\#156](https://github.com/theforeman/puppet-dhcp/pull/156) ([alexjfisher](https://github.com/alexjfisher))

## [5.0.0](https://github.com/theforeman/puppet-dhcp/tree/5.0.0) (2019-04-15)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/4.3.0...5.0.0)

**Breaking changes:**

- drop Puppet 4 [\#152](https://github.com/theforeman/puppet-dhcp/pull/152) ([mmoll](https://github.com/mmoll))
- drop EOL OSes [\#151](https://github.com/theforeman/puppet-dhcp/pull/151) ([mmoll](https://github.com/mmoll))

**Implemented enhancements:**

- Make the config header configurable [\#149](https://github.com/theforeman/puppet-dhcp/pull/149) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- fix missing authoritative statement [\#147](https://github.com/theforeman/puppet-dhcp/pull/147) ([qs5779](https://github.com/qs5779))

## [4.3.0](https://github.com/theforeman/puppet-dhcp/tree/4.3.0) (2019-01-10)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/4.2.0...4.3.0)

**Implemented enhancements:**

- update FreeBSD pkg name and support 12.x [\#144](https://github.com/theforeman/puppet-dhcp/pull/144) ([mmoll](https://github.com/mmoll))
- Create some puppet-strings documentation [\#143](https://github.com/theforeman/puppet-dhcp/pull/143) ([ekohl](https://github.com/ekohl))
- Support Puppet 6 [\#141](https://github.com/theforeman/puppet-dhcp/pull/141) ([ekohl](https://github.com/ekohl))

## [4.2.0](https://github.com/theforeman/puppet-dhcp/tree/4.2.0) (2018-10-04)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/4.1.1...4.2.0)

**Implemented enhancements:**

- Support Ubuntu/bionic, remove Debian 7 & Fedora 25 [\#127](https://github.com/theforeman/puppet-dhcp/pull/127) ([mmoll](https://github.com/mmoll))
- make ddns-update-style adjustable [\#126](https://github.com/theforeman/puppet-dhcp/pull/126) ([zeromind](https://github.com/zeromind))

**Merged pull requests:**

- allow puppetlabs-stdlib 5.x [\#135](https://github.com/theforeman/puppet-dhcp/pull/135) ([mmoll](https://github.com/mmoll))
- allow puppetlabs-concat 5.x [\#134](https://github.com/theforeman/puppet-dhcp/pull/134) ([mmoll](https://github.com/mmoll))
- Mark compatible with camptocamp-systemd 2.0 [\#131](https://github.com/theforeman/puppet-dhcp/pull/131) ([mateusz-gozdek-sociomantic](https://github.com/mateusz-gozdek-sociomantic))

## 4.1.1

* Correct listening on EL7 when using `$interface`

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
