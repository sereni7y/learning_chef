# Apache tomcat deployment

#install java
package 'openjdk-7-jre-headless'

#create group
group node['tomcat']['user.group'] do
  action :create
end

#create a tomcat user
user node['tomcat']['user'] do
  comment node['tomcat']['user'] + ' user'
  home node['tomcat']['user.home.dir']
  shell node['tomcat']['user.shell'] 
  group node['tomcat']['user.group']
  manage_home node['tomcat']['manage_home']
  action :create
end

#create a directory for tomcat
directory node['tomcat']['install.dir'] do
  owner node['tomcat']['user']
  group node['tomcat']['user.group']
  mode node['tomcat']['install.dir.mode']
  recursive true
  action :create
end

#download tomcat binary to /vagrant to save bandwidth
remote_file '/vagrant/' + node['tomcat']['version'] + '.tar.gz' do
  owner node['tomcat']['user']
  group node['tomcat']['user.group']
  mode node['tomcat']['install.dir.mode']
  source node['tomcat']['download.url'] + node['tomcat']['version'] + '.tar.gz'
  action :create
end

#copy file from /vagrant to the planned install directory
remote_file node['tomcat']['install.dir'] + node['tomcat']['version'] + '.tar.gz' do
  owner node['tomcat']['user']
  group node['tomcat']['user.group']
  mode node['tomcat']['install.dir.mode']
  source 'file:///vagrant/' + node['tomcat']['version'] + '.tar.gz'
  action :create
end

#unpack the tar, there is no inbuild chef way to do this
#Shell out
execute 'extract_tomcat_tar' do
  command 'tar xzvf' + node['tomcat']['install.dir'] + node['tomcat']['version'] + '.tar.gz && chown -R tomcat:tomcat /opt/tomcat/apache-tomcat-8.5.9'
  cwd '/opt/tomcat/'
  not_if { File.directory?(node['tomcat']['install.dir'] + node['tomcat']['version']) }
end

template '/etc/init/tomcat.conf' do
  source 'tomcat.conf.erb'
  owner node['tomcat']['user']
  group node['tomcat']['user.group']
  mode '0755'
end

service node['tomcat']['user'] do
  action [:reload, :start, :enable]
end

