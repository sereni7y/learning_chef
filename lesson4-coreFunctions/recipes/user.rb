#
# Cookbook:: lesson4-coreFunctions
# Recipe:: user
#
# Copyright:: 2017, The Authors, All Rights Reserved.

#create group
group node['app']['user.group'] do
	action :create
end

#create a tomcat user
user node['app']['user'] do
	comment node['app']['user'] + ' user'
	home node['app']['user.home']
	shell node['app']['user.shell']
	group node['app']['user.group']
	manage_home node['app']['user.manage_home']
	action :create
end
