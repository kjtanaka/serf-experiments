# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2

serf_version = node["serf"]["version"]
serf_download_url = node["serf"]["download_url"]
serf_download_dir = node["serf"]["download_dir"]
my_address = node[:network][:interfaces][:eth1][:addresses].detect{|k,v| v[:family] == "inet" }.first

packages = %w[wget unzip]

packages.each do |package|
    package "#{package}" do
          action :install
    end
end

execute "update 127.0.0.1" do
  command "sed -i -e \"s|127.0.0.1.*|127.0.0.1 localhost localhost.localdomain|\" /etc/hosts"
  not_if "grep \"127.0.0.1 localhost localhost.localdomain\" /etc/hosts"
end

remote_file "#{serf_download_dir}/serf-#{serf_version}.zip" do
  source "#{serf_download_url}"
  mode "0644"
  owner "root"
  group "root"
  action :create_if_missing
end

directory "/opt/serf/sbin" do
  owner "root"
  group "root"
  mode 00700
  recursive true
  action :create
end

execute "unzip serf zip file" do
  command "unzip serf-#{serf_version}.zip -d /opt/serf/sbin"
  cwd "#{serf_download_dir}"
  creates "/opt/serf/sbin/serf"
end

directory "/opt/serf/etc" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

template "/opt/serf/etc/serf.json" do
  source "conf/serf.json.erb"
  mode "0644"
  owner "root"
  group "root"
  action :create
  variables(
    :bind_address => my_address)
end

directory "/opt/serf/var/log" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

directory "/opt/serf/libexec" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

cookbook_file "/opt/serf/libexec/join.sh" do
  source "libexec/join.sh"
  mode "0700"
  owner "root"
  group "root"
  action :create
end

cookbook_file "/opt/serf/libexec/leave.sh" do
  source "libexec/leave.sh"
  mode "0700"
  owner "root"
  group "root"
  action :create
end

cookbook_file "/etc/init.d/serf" do
  source "init.d/serf"
  mode "0700"
  owner "root"
  group "root"
  action :create
end

execute "restart serf" do
  command "/etc/init.d/serf restart"
end

execute "check config serf on" do
  command "chkconfig serf on"
end

