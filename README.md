mruby Cookbook
==============

This cookbook installs mruby.

- /usr/local/bin/mruby
- /usr/local/bin/mirb
- /usr/local/bin/mrbc

TODO
----

- create LWRP


Requirements
------------

- make

Attributes
----------


- `[:mruby][:build_dir] = '/opt/chef_mruby'` # directory to build
- `[:mruby][:use_chef_ruby] = true`          # Use ruby chef runtime.
- `[:mruby][:add_path] = '/usr/local/bin'`   # create symlink to. If you don't need link, set nil.
- `[:mruby][:bins] = %w(mruby mrbc mirb)`    # symlink target binaries


Usage
-----

include your `runlist`

- `build-essential` (optional)
- `mruby`


Test
---

### Install test dependencies

`bundle`

### test

`kitchen test`


Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:  Yukihiko Sawanobori (HiganWorks LLC)

under MIT License

