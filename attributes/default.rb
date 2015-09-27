default['nrpe']['manage'] = true
default['nrpe']['user'] = 'nagios'
default['nrpe']['group'] = 'nagios'
default['nrpe']['port'] = '5666'

default['nrpe']['packages'] = value_for_platform(
  %w(centos redhat fedora amazon) => { 'default' => %w(perl perl-Switch nrpe nagios-plugins-all nagios-plugins-nrpe) },
  %w(ubuntu) => { 'default' => %w(nagios-nrpe-server nagios-plugins nagios-plugins-basic nagios-plugins-standard nagios-snmp-plugins nagios-plugins-extra nagios-nrpe-plugin),
                  '14.04' => %w(nagios-nrpe-server nagios-plugins nagios-plugins-basic nagios-plugins-standard nagios-snmp-plugins nagios-plugins-extra nagios-plugins-common nagios-plugins-contrib nagios-nrpe-plugin)
}
)

default['nrpe']['service_name'] = value_for_platform_family(
  'debian' => 'nagios-nrpe-server',
  'rhel' => 'nrpe'
)

default['nrpe']['pid_dir'] = value_for_platform_family(
  'debian' => '/var/run/nagios',
  'rhel' => '/var/run'
)

default['nrpe']['log_dir'] = '/var/log/nrpe'
default['nrpe']['log_file'] = ::File.join(node['nrpe']['log_dir'], 'nrpe.log')

default['nrpe']['conf_dir'] = '/etc/nagios'
default['nrpe']['include_dir'] = ::File.join(node['nrpe']['conf_dir'], 'nrpe.d')

default['nrpe']['conf_file'] = ::File.join(node['nrpe']['conf_dir'], 'nrpe.cfg')

default['nrpe']['options']['allow_arguments'] = 0
default['nrpe']['options']['allowed_hosts'] = %w(localhost 127.0.0.1)
default['nrpe']['options']['log_facility'] = 'daemon'
default['nrpe']['options']['debug'] = 0
default['nrpe']['options']['command_timeout'] = 60
default['nrpe']['options']['connection_timeout'] = 300

default['nrpe']['configure_rsyslog'] = true

case node['platform_family']
when 'rhel'
  case node['kernel']['machine']
  when 'x86_64'
    default['nrpe']['plugins_dir'] = '/usr/lib64/nagios/plugins'
  else
    default['nrpe']['plugins_dir'] = '/usr/lib/nagios/plugins'
  end
when 'debian'
  default['nrpe']['plugins_dir'] = '/usr/lib/nagios/plugins'
end

default['nrpe']['checks'] = {}
