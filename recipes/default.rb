#
# Cookbook Name:: nrpe
# Recipe:: default
#
# Copyright 2014, Virender Khatri
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

# install nrpe packages
node['nrpe']['packages'].each do |p|
  package p do
    only_if { node['nrpe']['manage'] }
    options '--no-install-recommends' if node['platform_family'] == 'debian'
  end
end

directory node['nrpe']['conf_dir'] do
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  recursive true
  only_if { node['nrpe']['manage'] }
end

directory node['nrpe']['include_dir'] do
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  recursive true
  only_if { node['nrpe']['manage'] }
end

directory node['nrpe']['log_dir'] do
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  only_if { node['nrpe']['manage'] }
end

template '/etc/rsyslog.d/01-nrpe.conf' do
  owner 'root'
  group 'root'
  mode 0644
  source 'rsyslog.conf.erb'
  variables(:log_file => node['nrpe']['log_file'],
            :log_facility => node['nrpe']['options']['log_facility']
           )
  only_if { node['nrpe']['manage'] && ::File.exist?('/etc/rsyslog.d') }
end

template node['nrpe']['conf_file'] do
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0644
  cookbook node['nrpe']['cookbook']
  source node['nrpe']['template']
  variables(:service_name => node['nrpe']['service_name'],
            :pid_dir => node['nrpe']['pid_dir'],
            :port => node['nrpe']['port'],
            :user => node['nrpe']['user'],
            :group => node['nrpe']['group'],
            :options => node['nrpe']['options'],
            :include_dir => node['nrpe']['include_dir'],
            :plugins_dir => node['nrpe']['plugins_dir']
           )
  notifies :restart, 'service[nrpe]', :delayed
  only_if { node['nrpe']['manage'] }
end

template "/etc/init.d/#{node['nrpe']['service_name']}" do
  owner 'root'
  group 'root'
  mode 0755
  source "init.nrpe.cfg.#{node['platform_family']}.erb"
  variables(:conf_file => node['nrpe']['conf_file'])
  notifies :restart, 'service[nrpe]', :delayed
  only_if { node['nrpe']['manage'] }
end

service 'nrpe' do
  service_name node['nrpe']['service_name']
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
  only_if { node['nrpe']['manage'] }
end

include_recipe 'nrpe::checks'
