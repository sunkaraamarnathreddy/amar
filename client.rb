Ohai::Config[:disabled_plugins] = [:Passwd]
audit_mode       :enabled
chef_server_url  'https://chefserver-cm-us.pal.sap.corp/organizations/glds'
enable_reporting true
enable_reporting_url_fatals false
log_level        :info
log_location     'c:/chef/chef-client.log'
ssl_verify_mode  :verify_none
validation_client_name 'glds-validator'
validation_key   'c:/chef/glds-validator.pem'
no_proxy         '*.sap.corp'