#
# Cookbook Name:: nrpe
# Recipe:: check_load
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

check_load_warning = (node['cpu']['total'].to_f * node['nrpe']['threshold']['warning']['cpu_load'].to_f).round / 100.0
check_load_critical = (node['cpu']['total'].to_f * node['nrpe']['threshold']['critical']['cpu_load'].to_f).round / 100.0

nrpe 'check_load' do
  plugin_name 'check_load'
  plugin_args "-w #{check_load_warning},#{check_load_warning},#{check_load_warning} -c #{check_load_critical},#{check_load_critical},#{check_load_critical}"
  action :nothing unless node['nrpe']['manage']
end
