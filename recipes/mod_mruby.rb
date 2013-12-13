## This recipe must use with apache cookbook(community cookbook)

include_recipe 'mruby::default'

case node[:platform_family]
when 'debian'
  include_recipe 'apt::default'
  include_recipe 'apache2'
  package node[:apache][:package] + '-dev'
  apxs_cmd = 'apxs2'
when 'rhel'
  include_recipe 'apache2'
  package node[:apache][:package] + '-devel'
  apxs_cmd = 'apxs'
end

git ::File.join(node[:mruby][:build_dir],'mod_mruby') do
  action :sync
  reference node[:mruby][:mod_mruby][:git_refernce]
  repository 'https://github.com/matsumoto-r/mod_mruby.git'
  enable_submodules true
end

bash 'sync_built_mruby' do
  code <<-EOL
    rsync -avz #{::File.join(node[:mruby][:build_dir],'mruby/')} #{::File.join(node[:mruby][:build_dir],'mod_mruby', 'mruby/')}
  EOL
end

bash 'build_mod_mruby' do
  flags '-e'
  cwd ::File.join(node[:mruby][:build_dir],'mod_mruby')
  path [::File.dirname(RbConfig.ruby)]
  environment 'RAKE_PATH' => ::File.join(::File.dirname(RbConfig.ruby), 'rake')
  code <<-EOL
    ./configure `which #{apxs_cmd}` `which apachectl`
    make
    make install
  EOL
end

# call a2enmod
apache_module 'mruby' do
  conf true
end
