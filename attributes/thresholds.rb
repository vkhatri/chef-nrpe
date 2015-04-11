# adjust accordingly
default['nrpe']['threshold']['warning']['cpu_load'] = 100
default['nrpe']['threshold']['critical']['cpu_load'] = 125

default['nrpe']['threshold']['warning']['check_disk_mounts'] = 15
default['nrpe']['threshold']['critical']['check_disk_mounts'] = 10

default['nrpe']['threshold']['warning']['check_mem'] = 5
default['nrpe']['threshold']['critical']['check_mem'] = 2

default['nrpe']['threshold']['warning']['check_zombie_procs'] = 5
default['nrpe']['threshold']['critical']['check_zombie_procs'] = 10

default['nrpe']['threshold']['warning']['check_cpu_iowait'] = 25
default['nrpe']['threshold']['critical']['check_cpu_iowait'] = 50

default['nrpe']['threshold']['warning']['check_chef_client_file_age'] = 3600
default['nrpe']['threshold']['critical']['check_chef_client_file_age'] = 5400

default['nrpe']['threshold']['warning']['check_ntp_peer'] = 0.5
default['nrpe']['threshold']['critical']['check_ntp_peer'] = 1.0

default['nrpe']['threshold']['warning']['check_procs'] = 16_000
default['nrpe']['threshold']['critical']['check_procs'] = 32_000

default['nrpe']['threshold']['warning']['check_cpu.sh'] = 90
default['nrpe']['threshold']['critical']['check_cpu.sh'] = 100

default['nrpe']['threshold']['warning']['check_file_age'] = 3600
default['nrpe']['threshold']['critical']['check_file_age'] = 7200
