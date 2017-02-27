#
# Cookbook:: lesson4-wrapper
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.override['app']['user.group'] = 'tomcat'
node.override['app']['user'] = 'tomcat'
node.override['app']['user.home'] = '/home/tomcat'
node.override['app']['user.shell'] = '/bin/bash'
node.override['app']['user.manage_home'] = true
node.override['app']['install.dir'] = '/opt/tomcat'
node.override['app']['install.dir.mode'] = '0755'
node.override['app']['name'] = 'tomcat'
node.override['app']['config.file.loc'] = '/etc/init/tomcat.conf'
node.override['app']['config.file'] = 'tomcat.conf.erb'

include_recipe 'lesson4-coreFunctions::default'
