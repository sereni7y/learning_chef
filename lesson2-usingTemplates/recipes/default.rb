# Apache tomcat deployment

#install java
package 'openjdk-7-jre-headless'

#create group
group 'tomcat' do
  action :create
end

#create a tomcat user
user 'tomcat' do
  comment 'Tomcat user'
  home '/home/tomcat'
  shell '/bin/bash'
  group 'tomcat'
  manage_home true
  action :create
end

#create a directory for tomcat
directory '/opt/tomcat' do
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  recursive true
  action :create
end

#download tomcat binary to /vagrant to save bandwidth
remote_file '/vagrant/apache-tomcat-8.5.9.tar.gz' do
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  source 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz'
  action :create
end

#copy file from /vagrant to the planned install directory
remote_file '/opt/tomcat/apache-tomcat-8.5.9.tar.gz' do
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  source 'file:///vagrant/apache-tomcat-8.5.9.tar.gz'
  action :create
end

#unpack the tar, there is no inbuild chef way to do this
#Shell out
execute 'extract_tomcat_tar' do
  command 'tar xzvf /opt/tomcat/apache-tomcat-8.5.9.tar.gz && chown -R tomcat:tomcat /opt/tomcat/apache-tomcat-8.5.9'
  cwd '/opt/tomcat/'
  not_if { File.directory?('/opt/tomcat/apache-tomcat-8.5.9')}
end

template '/etc/init/tomcat.conf' do
  source 'tomcat.conf.erb'
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
end

service 'tomcat' do
  action [:reload, :start, :enable]
end
