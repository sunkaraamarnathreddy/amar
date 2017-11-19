# Cookbook Name:: litc-glds-runlist
# Recipe:: default
#
# Copyright 2017, SAP
#
# All rights reserved - Do Not Redistribute
#

# Splunk reporting for chef client execution
include_recipe 'litc-chef-agent::splunk_handler'

# GLDS inventory
include_recipe 'glds-inventory'

# Do not run on the following SISM CUSTOMERs
return if %w(5482 6538 6968).include? node['SISM_CUSTOMER'].to_s

# mmci_all
include_recipe 'litc-glds-ntp'
include_recipe 'litc-glds-dnssuffix'
include_recipe 'litc-glds-findsid'
include_recipe 'litc-glds-osconfig-files'

case node['platform_family']
when 'windows'
  # mmci_windows
  include_recipe 'litc-glds-bginfo'
  include_recipe 'litc-mmci::remove_domain_users_windows'
  include_recipe 'litc-glds-rsh'
  include_recipe 'litc-mmci-winrm-service'

when 'suse', 'rhel'
  # mmci_linux
  include_recipe 'litc-glds-motd'
  include_recipe 'litc-mmci::postfix'
  include_recipe 'litc-mmci::shadow_algorithm_linux'

  # cookbooks specific to SISM
  case node['SISM_SERVICE_GROUP']
  # for Server Provisining Lab servers
  when '01481'
    # blocking usage of rlogin, rsh, rcp and telnet
    include_recipe 'litc-base-line-hardening::BL1-30-01'
    # disabling the X Window System
    include_recipe 'litc-base-line-hardening::BL1-30-03'
  # for Labs IT Standard and Premium servers
  when '01365'
    # blocking usage of rlogin, rsh, rcp and telnet
    include_recipe 'litc-base-line-hardening::BL1-30-01'
    # disabling the X Window System
    include_recipe 'litc-base-line-hardening::BL1-30-03'
  # for LABS IT Production servers
  when '01503'
    # blocking usage of rlogin, rsh, rcp and telnet
    include_recipe 'litc-base-line-hardening::BL1-30-01'
    # disabling the X Window System
    include_recipe 'litc-base-line-hardening::BL1-30-03'
  end
end
