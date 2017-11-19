if node['os'] == 'linux'
  chef_path = Pathname.new('/etc/chef')

  directory chef_path.to_s do
    action :create
    recursive true
  end

  template "#{chef_path}/agent.rb" do
    source 'agent.rb.erb'
    action :create
  end

  cron 'chef_client' do
    minute '0'
    user 'root'
    command "/opt/chef/embedded/bin/ruby #{chef_path}/agent.rb > /etc/chef/agent.log > /dev/null 2>&1"
    action :create
    only_if { ::File.exist?("#{chef_path}/agent.rb") }
    not_if { ::File.exist?('/var/adm/local/cron.liste') }
  end

  ruby_block 'update /var/adm/local/cron.liste for agent.rb run' do
    block do
      file = Chef::Util::FileEdit.new('/var/adm/local/cron.liste')
      file.search_file_replace_line(%r{ruby /etc/chef/agent\.rb}, '0 * * * * /opt/chef/embedded/bin/ruby /etc/chef/agent.rb > /etc/chef/agent.log > /dev/null 2>&1')
      file.insert_line_if_no_match(%r{ruby /etc/chef/agent\.rb}, '#Chef-Client cronjob
0 * * * * /opt/chef/embedded/bin/ruby /etc/chef/agent.rb > /etc/chef/agent.log > /dev/null 2>&1')
      file.write_file
    end
    action :run
    only_if { ::File.exist?('/var/adm/local/cron.liste') }
    not_if { ::File.readlines('/var/adm/local/cron.liste').grep(%r{^0 \* \* \* \* /opt/chef/embedded/bin/ruby /etc/chef/agent\.rb}).any? }
  end

else

  chef_path = Pathname.new('C:\chef')

  directory chef_path.to_s do
    action :create
    recursive true
  end

  template "#{chef_path}/agent.rb" do
    source 'agent.rb.erb'
    action :create
  end

  windows_task 'chef_client' do
    command "C:/opscode/chef/embedded/bin/ruby #{chef_path}/agent.rb > c:/chef/agent.log"
    frequency :hourly
    frequency_modifier 1
    start_time '00:00'
    action :create
    run_level :highest
    only_if { File.exist?("#{chef_path}/agent.rb") }
  end
end
