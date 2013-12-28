# vim: tabstop=4 expandtab shiftwidth=2 softtabstop=2

serf_version = node["serf"]["version"]
serf_download_url = node["serf"]["download_url"]
serf_download_dir = node["serf"]["download_dir"]

packages = %w[wget unzip]

packages.each do |package|
    package "#{package}" do
          action :install
    end
end

remote_file "#{serf_download_dir}/serf-#{serf_version}.zip" do
  source "#{serf_download_url}"
  mode "0644"
end

execute "unzip serf zip file" do
  command "unzip serf-#{serf_version}.zip -d /usr/bin"
  cwd "#{serf_download_dir}"
  creates "/usr/bin/serf"
end

directory "/etc/serf" do
  owner "root"
  group "root"
  mode 00755
  action :create
end

cookbook_file "/etc/serf/serf.conf" do
  source "serf.conf"
  mode "0644"
  owner "root"
  group "root"
  action :create_if_missing
end
