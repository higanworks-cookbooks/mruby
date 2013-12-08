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

git ::File.join(node[:mruby][:build_dir],'mruby') do
  action :sync
  reference node[:mruby][:git_refernce]
  repository 'https://github.com/mruby/mruby.git'
  notifies :create, 'template[mruby_build_config]', :immediately
  notifies :run, 'bash[build mruby]', :immediately
end

template 'mruby_build_config' do
  action :create
  path ::File.join(node[:mruby][:build_dir],'mruby/build_config_chef.rb')
  source 'build_config.erb'
  variables node[:mruby][:build_options]
end

bash 'build mruby' do
  if node[:mruby][:use_chef_ruby]
    rubybin = RbConfig.ruby
  else
    rubybin = `which ruby`.chomp
  end
  if node[:mruby][:force_rebuild]
    action :run
  else
    action :nothing
  end
  flags '-ex'
  environment 'MRUBY_CONFIG' => 'build_config_chef.rb',
              'BUILD_TYPE' => node[:mruby][:build_type]
  cwd ::File.join(node[:mruby][:build_dir], 'mruby')
  code <<-__EOL__
     #{rubybin} minirake
  __EOL__
end

node[:mruby][:build_options][:bins].each do |binary|
  if node[:mruby][:add_path]
    link ::File.join(node[:mruby][:add_path], binary) do
      action :create
      to ::File.join(node[:mruby][:build_dir], 'mruby' , 'bin',  binary)
    end
  end
end
