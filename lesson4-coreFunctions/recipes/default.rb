#
# Cookbook:: lesson4-coreFunctions
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'java::default'
include_recipe 'lesson4-coreFunctions::user'
include_recipe 'lesson4-coreFunctions::filesystem'
include_recipe 'lesson4-coreFunctions::deploy'
include_recipe 'lesson4-coreFunctions::configure'
