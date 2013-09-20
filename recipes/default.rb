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
  mode 0755
end

git '/opt/chef_mruby/mruby' do
  action :sync
  repository 'https://github.com/mruby/mruby.git'
  notifies :run, 'bash[build mruby]', :immediately
end

bash 'build mruby' do
  if node[:mruby][:use_chef_ruby]
    rubybin = RbConfig.ruby
  else
    rubybin = `which ruby`.chomp
  end
  action :nothing
  flags '-ex'
  cwd ::File.join(node[:mruby][:build_dir], 'mruby')
  code <<-__EOL__
     #{rubybin} minirake
  __EOL__
end

node[:mruby][:bins].each do |binary|
  if node[:mruby][:add_path]
    link ::File.join(node[:mruby][:add_path], binary) do
      action :create
      to ::File.join(node[:mruby][:build_dir], 'mruby' , 'bin',  binary)
    end
  end
end
