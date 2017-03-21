default['systemd']['units_dir'] = '/etc/systemd/system'

default['java']['jdk_version'] = '7'
default['java']['install_flavor'] = 'oracle'
default['java']['set_default'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true

default['cassandra']['tarball_purge'] = false
default['cassandra']['install_method'] = 'datastax'
default['cassandra']['install_java'] = true
default['cassandra']['notify_restart'] = false
default['cassandra']['initial_token'] = ''
default['cassandra']['service_name'] = 'cassandra'
default['cassandra']['user'] = 'cassandra'
default['cassandra']['group'] = 'cassandra'
default['cassandra']['setup_user'] = true
default['cassandra']['setup_user_limits'] = true
default['cassandra']['user_home'] = nil
default['cassandra']['system_user'] = true
default['cassandra']['version'] = '2.2.0'
default['cassandra']['use_systemd'] = false
default['cassandra']['use_initd'] = true

# jamm library was added in v0.8.0 and
# not required for later versions
default['cassandra']['setup_jamm'] = false

default['cassandra']['setup_priam'] = false
default['cassandra']['priam']['base_url'] = "http://search.maven.org/remotecontent?filepath=com/netflix/priam/priam-cass-extensions/#{node['cassandra']['version']}"
default['cassandra']['priam']['jar_name'] = "priam-cass-extensions-#{node['cassandra']['version']}.jar"
default['cassandra']['priam']['sha256sum'] = '9fde9a40dc5c538adee54f40fa9027cf3ebb7fd42e3592b3e6fdfe3f7aff81e1'

default['cassandra']['pid_dir'] = '/var/run/cassandra'
default['cassandra']['dir_mode'] = '0755'
default['cassandra']['service_action'] = [:enable, :start]
default['cassandra']['jmx_port'] = 7199
default['cassandra']['local_jmx'] = true
default['cassandra']['jmx_remote_rmi_port'] = '$JMX_PORT'
default['cassandra']['jmx_remote_authenticate'] = false
default['cassandra']['jmx']['user'] = 'cassandra'
default['cassandra']['jmx']['password'] = 'cassandra'

default['cassandra']['limits']['memlock'] = 'unlimited'
default['cassandra']['limits']['nofile'] = 48_000
default['cassandra']['limits']['nproc'] = 'unlimited'

default['cassandra']['templates_cookbook'] = 'cassandra-dse'

default['cassandra']['root_dir'] = '/var/lib/cassandra' # data/ subdir added to this root
default['cassandra']['log_dir'] = '/var/log/cassandra'
default['cassandra']['rootlogger'] = 'INFO,stdout,R'

# Seed node discovery
default['cassandra']['seeds'] = node['ipaddress']

default['cassandra']['seed_discovery']['use_chef_search'] = false
default['cassandra']['seed_discovery']['count'] = 3
default['cassandra']['seed_discovery']['search_role'] = 'cassandra-seed'
default['cassandra']['seed_discovery']['search_query'] = nil

default['cassandra']['jbod']['slices'] = nil
default['cassandra']['jbod']['dir_name_prefix'] = 'data'

default['cassandra']['logback']['file']['max_file_size'] = '20MB'
default['cassandra']['logback']['file']['max_index'] = 20
default['cassandra']['logback']['file']['min_index'] = 1
default['cassandra']['logback']['file']['pattern'] = '%-5level [%thread] %date{ISO8601} %F:%L - %msg%n'

default['cassandra']['logback']['debug']['enable'] = false
default['cassandra']['logback']['debug']['max_file_size'] = '20MB'
default['cassandra']['logback']['debug']['max_index'] = 20
default['cassandra']['logback']['debug']['min_index'] = 1
default['cassandra']['logback']['debug']['pattern'] = '%-5level [%thread] %date{ISO8601} %F:%L - %msg%n'

default['cassandra']['logback']['stdout']['enable'] = true
default['cassandra']['logback']['stdout']['pattern'] = '%-5level [%thread] %date{ISO8601} %F:%L - %msg%n'

default['cassandra']['logback']['syslog']['enable'] = false
default['cassandra']['logback']['syslog']['host'] = 'localhost'
default['cassandra']['logback']['syslog']['facility'] = 'USER'
default['cassandra']['logback']['syslog']['pattern'] = '%-5level [%thread] %F:%L - %msg%n'

default['cassandra']['log4j'] = {}

data_dir = []
if !node['cassandra']['jbod']['slices'].nil?
  node['cassandra']['jbod']['slices'].times do |slice_number|
    data_dir << ::File.join(node['cassandra']['root_dir'], "#{node['cassandra']['jbod']['dir_name_prefix']}#{slice_number}")
  end
else
  data_dir << ::File.join(node['cassandra']['root_dir'], 'data')
end

default['cassandra']['data_dir'] = data_dir

default['cassandra']['max_heap_size'] = nil
default['cassandra']['heap_new_size'] = nil
default['cassandra']['xss'] = '256k'
default['cassandra']['vnodes'] = true
default['cassandra']['enable_assertions'] = true
default['cassandra']['internode_compression'] = 'all' # all, dc, none
default['cassandra']['jmx_server_hostname'] = false
default['cassandra']['metrics_reporter']['enabled'] = false
default['cassandra']['metrics_reporter']['name'] = 'metrics-graphite'
default['cassandra']['metrics_reporter']['jar_url'] = 'http://search.maven.org/remotecontent?filepath=com/yammer/metrics/metrics-graphite/2.2.0/metrics-graphite-2.2.0.jar'
default['cassandra']['metrics_reporter']['sha256sum'] = '6b4042aabf532229f8678b8dcd34e2215d94a683270898c162175b1b13d87de4'
default['cassandra']['metrics_reporter']['jar_name'] = 'metrics-graphite-2.2.0.jar'
default['cassandra']['metrics_reporter']['config'] = {} # should be a hash of relevant config

default['cassandra']['jamm']['version'] = jamm_version(node['cassandra']['version'])
default['cassandra']['jamm']['base_url'] = jamm_url(node['cassandra']['jamm']['version'])
default['cassandra']['jamm']['jar_name'] = "jamm-#{node['cassandra']['jamm']['version']}.jar"
default['cassandra']['jamm']['sha256sum'] = jamm_sha256sum(node['cassandra']['jamm']['version'])

# log configuration files
default['cassandra']['log_config_files'] = node['cassandra']['version'] =~ /^[0-1]|^2.0/ ? %w(log4j-server.properties) : %w(logback.xml logback-tools.xml)

# Heap Dump
default['cassandra']['heap_dump'] = true
default['cassandra']['heap_dump_dir'] = nil

# GC tuning options
default['cassandra']['jvm']['g1'] = false
default['cassandra']['jvm']['gcdetail'] = true

default['cassandra']['jvm']['max_gc_pause_millis'] = 200
default['cassandra']['jvm']['heap_occupancy_threshold'] = 45
default['cassandra']['jvm']['parallel_ref_proc'] = false
default['cassandra']['jvm']['max_parallel_gc_threads'] = nil
default['cassandra']['jvm']['max_conc_gc_threads'] = nil
default['cassandra']['jvm']['g1_rset_updating_pause_time_percent'] = 5
default['cassandra']['jvm']['g1_heap_region_size'] = 0
default['cassandra']['jvm']['always_pre_touch'] = false
default['cassandra']['jvm']['use_biased_locking'] = true
default['cassandra']['jvm']['use_tlab'] = true
default['cassandra']['jvm']['resize_tlab'] = true

default['cassandra']['gc_survivor_ratio'] = 8
default['cassandra']['gc_max_tenuring_threshold'] = 1
default['cassandra']['gc_cms_initiating_occupancy_fraction'] = 75

default['cassandra']['jna']['base_url'] = 'https://github.com/twall/jna/raw/4.0/dist'
default['cassandra']['jna']['jar_name'] = 'jna.jar'
default['cassandra']['jna']['sha256sum'] = 'dac270b6441ce24d93a96ddb6e8f93d8df099192738799a6f6fcfc2b2416ca19'

default['cassandra']['tarball']['url'] = 'auto'

default['cassandra']['opscenter']['version'] = nil
default['cassandra']['opscenter']['server']['package_name'] = 'opscenter'
default['cassandra']['opscenter']['server']['port'] = '8888'
default['cassandra']['opscenter']['server']['interface'] = '0.0.0.0'
default['cassandra']['opscenter']['server']['authentication'] = false
default['cassandra']['opscenter']['server']['ssl']['keyfile'] = '/var/lib/opscenter/ssl/opscenter.key'
default['cassandra']['opscenter']['server']['ssl']['certfile'] = '/var/lib/opscenter/ssl/opscenter.pem'
default['cassandra']['opscenter']['server']['ssl']['port'] = '8443'
default['cassandra']['opscenter']['server']['ssl']['enabled'] = true

default['cassandra']['opscenter']['cassandra_metrics']['ignored_keyspaces'] = %w(system OpsCenter)
default['cassandra']['opscenter']['cassandra_metrics']['ignored_column_families'] = []
default['cassandra']['opscenter']['cassandra_metrics']['1min_ttl'] = 604800
default['cassandra']['opscenter']['cassandra_metrics']['5min_ttl'] = 2419200
default['cassandra']['opscenter']['cassandra_metrics']['2hr_ttl'] = 31536000

default['cassandra']['opscenter']['custom_configuration'] = {}

default['cassandra']['opscenter']['agent']['package_name'] = 'datastax-agent'
default['cassandra']['opscenter']['agent']['download_url'] = nil
default['cassandra']['opscenter']['agent']['checksum'] = nil
default['cassandra']['opscenter']['agent']['install_dir'] = '/opt'
default['cassandra']['opscenter']['agent']['install_folder_name'] = 'opscenter_agent'
default['cassandra']['opscenter']['agent']['binary_name'] = 'opscenter-agent'
# if nil, will use search to get IP by server role
default['cassandra']['opscenter']['agent']['server_host'] = nil
default['cassandra']['opscenter']['agent']['use_chef_search'] = true
default['cassandra']['opscenter']['agent']['server_role'] = 'opscenter_server'
default['cassandra']['opscenter']['agent']['use_ssl'] = false
default['cassandra']['opscenter']['agent']['conf_dir'] = '/var/lib/datastax-agent/conf'
