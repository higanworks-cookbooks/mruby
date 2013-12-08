default[:mruby][:mod_mruby][:git_refernce] = 'master'

if node.recipes.include?('mruby::mod_mruby')
  Chef::Log.info 'Include apache2 default attributes'
  include_attribute 'apache2::default'
end
