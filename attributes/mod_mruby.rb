default[:mruby][:mod_mruby][:git_refernce] = 'master'

if node.recipes.include?('mruby::mod_mruby')
  Chef::Log.info 'Include apache2 all attributes'
  node.run_context.cookbook_collection[:apache2].attribute_filenames_by_short_filename.keys.each do |attr|
    Chef::Log.info "Include apache2::#{attr} attributes"
    include_attribute "apache2::#{attr}"
  end
end
