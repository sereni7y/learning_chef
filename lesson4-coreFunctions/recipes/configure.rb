#
# Cookbook:: lesson4-coreFunctions
# Recipe:: configure
#
# Copyright:: 2017, The Authors, All Rights Reserved.
template node['app']['config.file.loc'] do
  source node['app']['config.file']
  cookbook 'commonConfig'
end 
service node['app']['name'] do
	action [:reload, :start, :enable]
end

