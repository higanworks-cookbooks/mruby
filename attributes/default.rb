default[:mruby][:build_dir] = '/opt/chef_mruby'
default[:mruby][:use_chef_ruby] = true
default[:mruby][:add_path] = '/usr/local/bin'
default[:mruby][:git_refernce] = 'master'


## for buid_config template
default[:mruby][:build_type] = ''
default[:mruby][:build_options][:bins] = %w(mruby mrbc mirb)
default[:mruby][:build_options][:user_gems] = []

## User Gem example
#[:mruby][:build_options][:user_gems] = [
#  [':git', 'https://github.com/iij/mruby-io.git']
#]
