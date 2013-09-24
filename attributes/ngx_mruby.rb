default[:mruby][:ngx_mruby][:git_refernce] = 'master'

if node.recipes.include?('mruby::ngx_mruby')
  Chef::Log.info 'Include nginx default attributes'
  include_attribute 'nginx::default'
  include_attribute 'nginx::source'
end
