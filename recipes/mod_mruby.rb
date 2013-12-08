## This recipe should use with nginx cookbook(opscode)
## add to run_list nginx with set attribute node[:nginx][:install_method] == source after this recipe

include_recipe 'mruby::default'

if node[:platform_family] == 'debian'
  include_recipe 'apt::default'
  package node[:apache][:package] + '-dev'
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

bash 'build_mode_mruby' do
  cwd ::File.join(node[:mruby][:build_dir],'mod_mruby')
  path [::File.dirname(RbConfig.ruby)]
  environment 'RAKE_PATH' => ::File.join(::File.dirname(RbConfig.ruby), 'rake')
  code <<-EOL
    ./configure `which apxs2` `which apachectl`
    make
    make install
  EOL
end

## TODO: a2enmod
