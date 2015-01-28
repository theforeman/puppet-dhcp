# Changelog

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
