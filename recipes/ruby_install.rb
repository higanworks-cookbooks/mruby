include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby '2.0.0-p247' do
  global true
  retries 2
end

