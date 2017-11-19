# Splunk URL for Splunk Handler
default['litc-chef-agent']['splunk_url'] = 'https://10.76.63.32:8088/services/collector/event'

# Agent.rb delay in minute
default['litc-chef-agent']['random_delay'] = 1200

# Attributes to report to Splunks

default['litc-chef-agent']['reported_attributes'] = ['tags', Chef::Config['chef_server_url'].split('/').last.to_s, 'glds_sid']
