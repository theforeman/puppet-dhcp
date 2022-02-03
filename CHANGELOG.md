# Changelog

## [8.1.0](https://github.com/theforeman/puppet-dhcp/tree/8.1.0) (2022-02-03)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/8.0.0...8.1.0)

**Implemented enhancements:**

- Add Debian 11 and Ubuntu 20.04 support [\#208](https://github.com/theforeman/puppet-dhcp/pull/208) ([ekohl](https://github.com/ekohl))
- add support for raw configuration for host declarations. [\#206](https://github.com/theforeman/puppet-dhcp/pull/206) ([UiP9AV6Y](https://github.com/UiP9AV6Y))
- puppetlabs/stdlib: Allow 8.x [\#204](https://github.com/theforeman/puppet-dhcp/pull/204) ([bastelfreak](https://github.com/bastelfreak))
- Add support for multiple pools in a subnet [\#164](https://github.com/theforeman/puppet-dhcp/pull/164) ([peterverraedt](https://github.com/peterverraedt))

## [8.0.0](https://github.com/theforeman/puppet-dhcp/tree/8.0.0) (2021-10-29)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/7.0.0...8.0.0)

**Breaking changes:**

- Drop EL6 support [\#198](https://github.com/theforeman/puppet-dhcp/pull/198) ([ekohl](https://github.com/ekohl))
- Drop Debian 8 support and update default template [\#197](https://github.com/theforeman/puppet-dhcp/pull/197) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Depend on camptocamp/systemd ~\> 3.1 [\#202](https://github.com/theforeman/puppet-dhcp/pull/202) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Ensure systemd drop-in happens before service [\#199](https://github.com/theforeman/puppet-dhcp/pull/199) ([ekohl](https://github.com/ekohl))

**Closed issues:**

- Use of notify\_service requires systemd dependency version bump [\#201](https://github.com/theforeman/puppet-dhcp/issues/201)

## [7.0.0](https://github.com/theforeman/puppet-dhcp/tree/7.0.0) (2021-07-23)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/6.2.0...7.0.0)

**Breaking changes:**

- Drop Puppet 5 support [\#191](https://github.com/theforeman/puppet-dhcp/pull/191) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Mark compatible with camptocamp/systemd 3 [\#190](https://github.com/theforeman/puppet-dhcp/pull/190) ([ekohl](https://github.com/ekohl))
- Allow Puppet 7 compatible versions of mods [\#187](https://github.com/theforeman/puppet-dhcp/pull/187) ([ekohl](https://github.com/ekohl))
- Support Puppet 7 [\#186](https://github.com/theforeman/puppet-dhcp/pull/186) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- fix dhcp::host comment param [\#193](https://github.com/theforeman/puppet-dhcp/pull/193) ([jhoblitt](https://github.com/jhoblitt))

## [6.2.0](https://github.com/theforeman/puppet-dhcp/tree/6.2.0) (2021-01-26)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/6.1.0...6.2.0)

**Implemented enhancements:**

- add support for client-updates instruction for interim DDNS. [\#183](https://github.com/theforeman/puppet-dhcp/pull/183) ([UiP9AV6Y](https://github.com/UiP9AV6Y))

## [6.1.0](https://github.com/theforeman/puppet-dhcp/tree/6.1.0) (2020-09-22)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/6.0.0...6.1.0)

**Implemented enhancements:**

- Adjust config directory mode to the system defaults [\#177](https://github.com/theforeman/puppet-dhcp/pull/177) ([ezr-ondrej](https://github.com/ezr-ondrej))

## [6.0.0](https://github.com/theforeman/puppet-dhcp/tree/6.0.0) (2020-05-12)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/5.1.1...6.0.0)

**Breaking changes:**

- Use modern facts [\#175](https://github.com/theforeman/puppet-dhcp/issues/175)
- Default nameservers to an empty array [\#171](https://github.com/theforeman/puppet-dhcp/pull/171) ([jhoblitt](https://github.com/jhoblitt))

**Implemented enhancements:**

- Fixes [\#29189](https://projects.theforeman.org/issues/29189) - Support el8 [\#167](https://github.com/theforeman/puppet-dhcp/pull/167) ([wbclark](https://github.com/wbclark))
- Support iPXE without chain-loading [\#150](https://github.com/theforeman/puppet-dhcp/pull/150) ([neomilium](https://github.com/neomilium))

**Merged pull requests:**

- document failover parameters [\#170](https://github.com/theforeman/puppet-dhcp/pull/170) ([wbclark](https://github.com/wbclark))

## [5.1.1](https://github.com/theforeman/puppet-dhcp/tree/5.1.1) (2020-02-12)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/5.1.0...5.1.1)

**Implemented enhancements:**

- Add Debian 10 [\#163](https://github.com/theforeman/puppet-dhcp/pull/163) ([mmoll](https://github.com/mmoll))

## [5.1.0](https://github.com/theforeman/puppet-dhcp/tree/5.1.0) (2019-10-24)

[Full Changelog](https://github.com/theforeman/puppet-dhcp/compare/5.0.1...5.1.0)

**Implemented enhancements:**

- Added UEFI HTTP Boot support [\#160](https://github.com/theforeman/puppet-dhcp/pull/160) ([lzap](https://github.com/lzap))

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
