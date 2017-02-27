#
# Cookbook:: lesson4-coreFunctions
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.
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
