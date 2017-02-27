#
# Cookbook:: lesson4-coreFunctions
# Recipe:: filesystem
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#create a directory for tomcat
directory node['app']['install.dir'] do
	owner node['app']['user']
	group node['app']['user.group']
	mode node['app']['install.dir.mode']
	recursive true
	action :create
	
end
