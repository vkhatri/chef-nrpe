nrpe "check_iowait" do
  plugin_dir "/usr/lib/nagios/plugins"
  plugin_name "check_iowait.sh"
  plugin_args "10 20"
end

nrpe "check_load" do
  plugin_dir "/usr/lib/nagios/plugins"
  plugin_name "check_test"
  plugin_args "10 20"
  skip_check_installation true
end
