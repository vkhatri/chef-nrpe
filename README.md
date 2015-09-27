nrpe Cookbook
=============

[![Build Status](https://travis-ci.org/vkhatri/chef-nrpe.svg?branch=master)](https://travis-ci.org/vkhatri/chef-nrpe)

This is a [Chef] cookbook to manage [NRPE] using LWRP.


## Repository

https://github.com/vkhatri/chef-nrpe


## Supported Install Types

Currently NRPE installation is supported **ONLY** via Repository Packages.


## Recipes

- `nrpe::default` - recipe to install and configure NRPE client
- `nrpe::checks` - recipe to create NRPE LWRP checks using node attribute `node['nrpe']['checks']`


## LWRP

Recipe `default` installs required NRPE packages and also configure
main file `nrpe.cfg`.

There are no checks enabled by default. This task is left up to the
user as per requirement using LWRP.

All nrpe LWRP checks are create under directory defined by `node['nrpe']['include_dir']`.


**LWRP examples**


	icinga2_nrpe 'check_load' do
    install_check true
	  plugin_dir node['icinga2']['plugins_dir']
	  plugin_name 'check_load'
	  plugin_args "-w #{check_load_warning},#{check_load_warning},#{check_load_warning} \
	  -c #{check_load_critical},#{check_load_critical},#{check_load_critical}"
	end


*via node attribute*

    "default_attributes": {
      "nrpe": {
        "check_load": {
          "action": "create",
          "plugin_name": "check_load",
          "plugin_args": "-w 1,1,1 -c 2,2,2"
          }
        }
      }
    }


**LWRP Resource attributes**

Parameters:

- *command_name (name attribute)*     - nrpe check command name
- *action (optional)*         - default :create, options: :create, :delete
- *plugin_dir (optional)*          - nrpe plugin lib directory
- *plugin_name (required)*           - nrpe plugin name
- *plugin_args (required)*          - nrpe plugin check command arguments
- *install_check*         - whether or not to install check sourcecode "plugin_name" to plugin_dir (default: false)


## Cookbook Core Attributes

 * `default['nrpe']['manage']` (default: `true`): whether to setup nrpe client

 * `default['nrpe']['user']` (default: `nagios`): nrpe user

 * `default['nrpe']['port']` (default: `5666`): nrpe service port

 * `default['nrpe']['packages']` (default: ``): nrpe packages to install

 * `default['nrpe']['service_name']` (default: ``): nrpe service name

 * `default['nrpe']['pid_dir']` (default: ``): nrpe service pid directory

 * `default['nrpe']['conf_dir']` (default: `/etc/nagios`): nrpe config directory

 * `default['nrpe']['include_dir']` (default: `/etc/nagios/nrpe.d`): nrpe checks config include directory

 * `default['nrpe']['conf_file']` (default: `/etc/nagios/nrpe.cfg`): nrpe configuration file

 * `default['nrpe']['plugins_dir']` (default: ``): nrpe plugins directory

 * `default['nrpe']['configure_rsyslog']` (default: `true`): create rsyslog conf file for nrpe log redirection

 * `default['nrpe']['options']['allow_arguments']` (default: `0`): nrpe configuration parameter `allow_arguments`

 * `default['nrpe']['options']['allowed_hosts']` (default: `['localhost', '127.0.0.1']`): nrpe configuration parameter `allowed_hosts`

 * `default['nrpe']['options']['debug']` (default: `0`): nrpe configuration parameter `debug`

 * `default['nrpe']['options']['command_timeout']` (default: `60`): nrpe configuration parameter `command_timeout`

 * `default['nrpe']['options']['connection_timeout']` (default: `300`): nrpe configuration parameter `connection_timeout`

 * `default['nrpe']['options']['log_facility']` (default: `daemon`): nrpe configuration parameter `log_facility`

 * `default['nrpe']['options']['debug']` (default: `0`): nrpe configuration parameter `debug`


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests (`rake`), ensuring they all pass
6. Write new resource/attribute description to `README.md`
7. Write description about changes to PR
8. Submit a Pull Request using Github


## Copyright & License

Authors:: Virender Khatri and [Contributors]

<pre>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>


[NRPE]: http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details
[Chef]: https://www.chef.io/
[Contributors]: https://github.com/vkhatri/chef-nrpe/graphs/contributors
