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

remote_file ::File.join(node['nrpe']['plugins_dir'], 'check_mem.pl') do
  source 'https://raw.githubusercontent.com/justintime/nagios-plugins/master/check_mem/check_mem.pl'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  action :create_if_missing
  only_if { node['nrpe']['manage'] }
end

remote_file ::File.join(node['nrpe']['plugins_dir'], 'check_disk_mounts') do
  source "https://raw.githubusercontent.com/vkhatri/nagios-plugin-check-disk-mounts/master/#{node['platform_family']}/check_disk_mounts"
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  only_if { node['nrpe']['manage'] }
end

remote_file ::File.join(node['nrpe']['plugins_dir'], 'check_iostat.sh') do
  source 'http://exchange.nagios.org/components/com_mtree/attachment.php?link_id=3379&cf_id=24'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  only_if { node['nrpe']['manage'] }
  action :nothing
end

remote_file ::File.join(node['nrpe']['plugins_dir'], 'check_cpu_perf.sh') do
  source 'https://raw.githubusercontent.com/skywalka/check-cpu-perf/master/check_cpu_perf.sh'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  only_if { node['nrpe']['manage'] }
end

cookbook_file ::File.join(node['nrpe']['plugins_dir'], 'check_iowait.sh') do
  source 'check_iowait.sh'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  only_if { node['nrpe']['manage'] }
end

remote_file ::File.join(node['nrpe']['plugins_dir'], 'check_iostat.pl') do
  source 'https://raw.githubusercontent.com/zwindler/zwindler-monitoring-plugins/master/check_iostat/check_iostat.pl'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  only_if { node['nrpe']['manage'] }
end

service 'nrpe' do
  service_name node['nrpe']['service_name']
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
  only_if { node['nrpe']['manage'] }
end

include_recipe 'nrpe::checks'
