case node['platform_family']
when 'windows'
  directory "#{node['kernel']['os_info']['system_drive']}\\ProgramData" do
    action :nothing
  end.run_action(:create)
  cookbook_file "#{node['kernel']['os_info']['system_drive']}\\ProgramData\\gemrc" do
    source 'gemrc'
    backup 1
    action :nothing
  end.run_action(:create)
end
