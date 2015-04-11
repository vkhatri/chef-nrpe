#
# Cookbook Name:: nrpe
# Recipe:: check_zombie_procs
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

nrpe 'check_zombie_procs' do
  plugin_name 'check_procs'
  plugin_args "-w #{node['nrpe']['threshold']['warning']['check_zombie_procs']} -c #{node['nrpe']['threshold']['critical']['check_zombie_procs']} -s Z"
  action :nothing unless node['nrpe']['manage']
end
