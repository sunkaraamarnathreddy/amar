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
