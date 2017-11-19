#!/usr/bin/env ruby
require 'ohai'
require 'net/http'

def send_graylog(status, short_message, host, facility)
  begin
    uri = URI.parse('http://lit-graylog.mo.sap.corp:12202/gelf')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request.body = "{\"status\":\"#{status}\",\"short_message\":\"#{short_message}\", \"host\": \"#{host}\", \"facility\":\"#{facility}\"}"
    response = http.request(request)
  rescue
    puts "Can't access to graylog"
  end
end


# :nodoc:
module OS
  def self.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def self.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def self.unix?
    !OS.windows?
  end

  def self.linux?
    OS.unix? && !OS.mac?
  end
end

sleep rand(1200)

node = Ohai::System.new
node.all_plugins('hostname')
send_graylog('INFO', 'Agent heartbeat', node['fqdn'], 'chef-client-agent')

if OS.unix? || OS.linux?
  chef_path = '/etc/chef'
elsif OS.mac?
  chef_path = '~/'
elsif OS.windows?
  chef_path = 'c:/chef/'
else
  raise 'can not define OS'
end

File.delete("#{chef_path}/chef-client.log") if File.exist?("#{chef_path}/chef-client.log")

unless system("chef-client -c #{chef_path}/client.rb --logfile #{chef_path}/chef-client.log")
  if (File.readlines("#{chef_path}/chef-client.log").grep /Net::HTTPServerException: 401/).any?
    File.delete("#{chef_path}/client.pem") if File.exist?("#{chef_path}/client.pem")
    send_graylog('ERROR', 'HTTP Request Returned 401 Unauthorized', node['fqdn'], 'chef-client-agent')
  end

  if (File.readlines("#{chef_path}/chef-client.log").grep /FATAL: Net::HTTPServerException: 403/).any?
    send_graylog('ERROR', 'HTTP Request Returned 403 Forbidden', node['fqdn'], 'chef-client-agent')
  end
end
