require 'chef/log'

module SplunkModule
  # Graylog Handler Class
  class SplunkHandler < Chef::Handler
    def send_splunk(body)
      uri = URI.parse(node['litc-chef-agent']['splunk_url'])
      ENV['no_proxy'] = "#{ENV['no_proxy']},#{uri.host}"
      proxy = if ENV['http_proxy'].nil?
                ''
              else
                ENV['http_proxy'].gsub('http://', '')
              end
      proxy = URI.parse(proxy)
      http = Net::HTTP.new(uri.host, uri.port, proxy.host, proxy.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Authorization'] = 'Splunk 794889C2-EAB3-4CF0-A3D5-6230B91B4C4E'
      request['Content-Type'] = 'application/json'
      body = {
        event: body,
        index: 's2400_devops_coe',
      }.to_json
      request.body = body
      http.request(request)
    end

    def cookbook_updater
      updated_cookbook = []
      updated_resources.each do |resource|
        unless updated_cookbook.include?("#{resource.cookbook_name}::#{resource.recipe_name}")
          updated_cookbook.push("#{resource.cookbook_name}::#{resource.recipe_name}")
        end
      end
      updated_cookbook
    end

    def detailed_cookbook_updater
      final = {}
      updated_resources.each do |res|
        res_details = "#{res.resource_name}['#{res.name}'] #{res.source_line}"
        final["#{res.cookbook_name}::#{res.recipe_name}"] = if final.key?("#{res.cookbook_name}::#{res.recipe_name}")
                                                              final["#{res.cookbook_name}::#{res.recipe_name}"] + [res_details]
                                                            else
                                                              [res_details]
                                                            end
      end
      final
    end

    def report_attributes
      reported_attributes = {}

      node['litc-chef-agent']['reported_attributes'].each do |attribute|
        reported_attributes = reported_attributes.merge(attribute => node[attribute]) if node.attribute?(attribute)
      end

      reported_attributes = reported_attributes.merge(report_sism_entries)

      reported_attributes
    end

    def report_sism_entries
      sism_values = {}

      node.each do |key, value|
        sism_values = sism_values.merge(key => value) if key.include?('SISM')
      end

      sism_values
    end

    def report_success
      body = {
        facility: 'CHEF_HANDLER',
        status: 'INFO',
        short_message: 'Chef-Client run successfully',
        _recipes_updater: cookbook_updater,
        _detailed_cookbook_updater: detailed_cookbook_updater,
        _updated_resources: updated_resources.count,
        _total_resources: all_resources.count,
        _run_list: node['recipes'],
        _reported_attributes: report_attributes,
        _hostname: node['fqdn'],
        _ipaddress: node['ipaddress'],
        _platform: node['platform'],
        _environment: node.chef_environment,
        _platform_version: node['platform_version'],
        _chef_client_version: Chef::VERSION,
        _chef_server_url: Chef::Config['chef_server_url'],
        _organization: Chef::Config['chef_server_url'].split('/').last,
      }.to_json
      body
    end

    def report_faillure
      body = {
        facility: 'CHEF_HANDLER',
        status: 'ERROR',
        short_message: 'Chef-Client run failed',
        _error_message: run_status.formatted_exception,
        _run_list: node['recipes'],
        _reported_attributes: report_attributes,
        _hostname: node['fqdn'],
        _ipaddress: node['ipaddress'],
        _environment: node.chef_environment,
        _platform: node['platform'],
        _platform_version: node['platform_version'],
        _chef_client_version: Chef::VERSION,
        _chef_server_url: Chef::Config['chef_server_url'],
        _organization: Chef::Config['chef_server_url'].split('/').last,
      }.to_json
      body
    end

    def report
      body = if success?
               report_success
             else
               report_faillure
             end
      send_splunk(body)
    end
  end
end
