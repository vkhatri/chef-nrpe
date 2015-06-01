#
# Cookbook Name:: monitoring_client
# Recipe:: twemproxy
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

remote_file ::File.join(node['nrpe']['plugins_dir'], 'check_twemproxy') do
  source 'https://raw.githubusercontent.com/wanelo/nagios-checks/master/check_twemproxy'
  owner node['nrpe']['user']
  group node['nrpe']['group']
  mode 0755
  only_if { node['nrpe']['manage'] }
end

nrpe 'check_twemproxy' do
  plugin_name 'check_twemproxy'
  plugin_args '-h 127.0.0.1 -p 22222'
  action :nothing unless node['nrpe']['manage']
end
