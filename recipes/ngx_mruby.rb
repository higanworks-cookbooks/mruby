## This recipe should use with nginx cookbook(opscode)
## add to run_list nginx with set attribute node[:nginx][:install_method] == source after this recipe

include_recipe 'mruby::default'

git ::File.join(node[:mruby][:build_dir],'ngx_mruby') do
  action :sync
  reference node[:mruby][:ngx_mruby][:git_refernce]
  repository 'https://github.com/matsumoto-r/ngx_mruby.git'
  enable_submodules true
end

bash 'sync_built_mruby' do
  code <<-EOL
    rsync -avz #{::File.join(node[:mruby][:build_dir],'mruby/')} #{::File.join(node[:mruby][:build_dir],'ngx_mruby', 'mruby/')}
  EOL
end


ngx_mruby_modules = [
  "--add-module=#{::File.join(node[:mruby][:build_dir],'ngx_mruby')}",
  "--add-module=#{::File.join(node[:mruby][:build_dir],'ngx_mruby/dependence/ngx_devel_kit')}"
]

node.run_state['nginx_configure_flags'] = [] unless node.run_state['nginx_configure_flags']
node.run_state['nginx_configure_flags'] =
  node.run_state['nginx_configure_flags'] | ngx_mruby_modules

