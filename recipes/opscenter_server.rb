#
# Cookbook Name:: cassandra-dse
# Recipe:: opscenter_server
#
# Copyright 2011-2012, Michael S Klishin & Travis CI Development Team
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java' if node['cassandra']['install_java']
include_recipe 'cassandra-dse::repositories'

ops = node['cassandra']['opscenter']
ops_server = ops['server']

package ops_server['package_name'] do
  version ops['version']
  options node['cassandra']['yum']['options'] if node['platform_family'] == 'rhel'
end

service 'opscenterd' do
  supports restart: true, status: true
  action [:enable, :start]
  subscribes :restart, "package[#{ops_server['package_name']}]"
end

template '/etc/opscenter/opscenterd.conf' do
  source 'opscenterd.conf.erb'
  mode '0644'
  notifies :restart, 'service[opscenterd]', :delayed
end

receivers = node['cassandra']['opscenter']['server']['event-plugin']['email']['receivers']

receivers.each_with_index do |addr, index|
  template "/etc/opscenter/event-plugins/email#{index}.conf" do
    vars = {
      receiver: addr
    }
    source 'opscenter_event_plugin_email.erb'
    mode '0644'
    variables vars
    notifies :restart, 'service[opscenterd]', :delayed
  end
end

alert_endpoint = node['cassandra']['opscenter']['server']['event-plugin']['posturl']['endpoint']

unless alert_endpoint.empty?
  template '/etc/opscenter/event-plugins/posturl.conf' do
    source 'opscenter_event_plugin_posturl.erb'
    mode '0644'
    notifies :restart, 'service[opscenterd]', :delayed
  end
end
