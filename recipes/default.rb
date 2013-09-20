#
# Cookbook Name:: mruby
# Recipe:: default
#
# Copyright 2013, HiganWorks LLC.
#

include_recipe 'mruby::depends'

directory node[:mruby][:build_dir] do
  action :create
  owner 'root'
  group 'root'
  mode 0700
end

git '/opt/chef_mruby/mruby' do
  action :sync
  repository 'https://github.com/mruby/mruby.git'
  notifies :run, 'bash[build mruby]', :immediately
end

bash 'build mruby' do
  action :nothing
  flags '-ex'
  cwd ::File.join(node[:mruby][:build_dir], 'mruby')
  code <<-__EOL__
     `which ruby` minirake
  __EOL__
end

if node[:mruby][:add_path]
  link ::File.join(node[:mruby][:add_path], 'mruby') do
    action :create
    to ::File.join(node[:mruby][:build_dir], 'mruby' , 'bin',  'mruby')
  end
end
