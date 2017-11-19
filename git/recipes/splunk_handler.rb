include_recipe 'chef_handler'

template "#{node['chef_handler']['handler_path']}/splunkhandler.rb" do
  source 'splunkhandler.rb'
  action :nothing
end.run_action(:create)

chef_handler 'SplunkModule::SplunkHandler' do
  source "#{node['chef_handler']['handler_path']}/splunkhandler.rb"
  action :nothing
end.run_action(:enable)
