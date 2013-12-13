mruby Cookbook
==============

This cookbook installs mruby. 

- /usr/local/bin/mruby
- /usr/local/bin/mirb
- /usr/local/bin/mrbc

Includes recipe ngx_mruby helper.

[http://community.opscode.com/cookbooks/mruby](http://community.opscode.com/cookbooks/mruby)

Platform
-------

The following platforms are supported and tested under test kitchen:

* Ubuntu 12.04
* CentOS 6.4


TODO
----

- create LWRP

Requirements
------------

- gcc  (package or source)
- make (package or source)

### Recommends

- 'build-essential' (Communty)


### Depends

- 'nginx' (Communty)
- 'apache2' (Communty)


Attributes
----------

### default.rb

- `node[:mruby][:build_dir] - directory to build`
  -   default: `'/opt/chef_mruby'`
- `node[:mruby][:use_chef_ruby]`           - Use ruby chef runtime.
  -   default: `true`
- `node[:mruby][:add_path]`  - create symlink to. If you don't need link, set nil.
  -   default: `'/usr/local/bin'`
-   `node[:mruby][:git_refernce]` - branch or tag of mruby repository
  - default: `'master'`

- `node[:mruby][:build_options][:bins]`     - symlink target binaries
  - default:`%w(mruby mrbc mirb)`
- `node[:mruby][:build_options][:user_gems]` - user mgem to install
  - default:`[]`
  - Add user Gem example: Arrays of methd(Stting like a symbol) and url(Stting).

```
node[:mruby][:build_options][:user_gems] = [
  [':git', 'https://github.com/iij/mruby-io.git']
]
```

### depends.rb

- `node[:mruby][:depend_pkgs]` - packcage dependencies(`action :upgrade`)
  - default: `['git','rsync']`

### ngx_mruby.rb

- `node[:mruby][:ngx_mruby][:git_refernce]` - branch or tag of ngx_mruby repository
  - default: `'master'`


### mod_mruby.rb

- `node[:mruby][:mod_mruby][:git_refernce]` - branch or tag of mod_mruby repository
  - default: `'master'`

- node[:apache2][:mod_mruby][:config][:by_line] = puts lines to mruby.conf
  - default: ['AddHandler mruby-script .rb'] (Array)


Recipes
----

### default.rb

Install mruby to `/usr/local/bin`.

#### suggests cookbooks

- 'build-essential' (Opscode)

#### Usage

add `mruby::default` to run_list.


### depends.rb

Install package dependencies.

It's included by default.rb. Nothing to do.


### ruby_install(instability support)

install `ruby-2.0.0-p247` with rbenv to system global.

#### depends cookbooks

- rbenv cookbook(Community)

#### Usage

add `mruby::ruby_install` to run_list.

### ngx_mruby

Regist config option to nginx build options.

#### depends cookbooks

- nginx(Community)


### mod_mruby

Build mod_mruby.so and regist config to apache httpd .

#### depends cookbooks

- apache2(Community)


Usage
-----

add `mruby::ngx_mruby,nginx::default` to run_list.

### Example

**Attributes(test-kitchen format)**

```
- name: ngx_mruby
  run_list:
    - "recipe[build-essential::default]"
    - "recipe[mruby::ngx_mruby]"
    - "recipe[nginx]"
  attributes:
    nginx:
      install_method: source
      version: 1.4.2
      configure_flags: ["--with-debug"]
      source:
        modules:
          - http_ssl_module
          - http_geoip_module
          - http_realip_module
          - http_stub_status_module
          - http_gzip_static_module
    mruby:
      force_rebuild: true
      build_options:
        user_gems:
          -  [':git', 'https://github.com/iij/mruby-io.git']
```

ChefClient converges below.

```
# /opt/nginx-1.4.2/sbin/nginx -V
nginx version: nginx/1.4.2
built by gcc 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) 
TLS SNI support enabled
configure arguments:
--prefix=/opt/nginx-1.4.2
--conf-path=/etc/nginx/nginx.conf
--sbin-path=/opt/nginx-1.4.2/sbin/nginx
--with-debug
--add-module=/opt/chef_mruby/ngx_mruby
--add-module=/opt/chef_mruby/ngx_mruby/dependence/ngx_devel_kit
--with-http_ssl_module
--with-http_geoip_module
--with-ld-opt='-Wl,-R,/usr/local/lib -L /usr/local/lib'
--with-http_realip_module
--with-http_stub_status_module
--with-http_gzip_static_module
```

### Example (JSON style attribute)

```
{
  "run_list" : [
    "recipe[build-essential::default]",
    "recipe[mruby::ngx_mruby]",
    "recipe[nginx]"
  ],
  "mruby": {
    "force_rebuild" : true,
    "build_options" : {
       "user_gems" : [
          [":git", "https://github.com/iij/mruby-io.git"]
        ]
    }
  },
  "nginx" : {
    "install_method" : "source",
    "version" : "1.4.2",
    "configure_flags" : [
      "--with-debug"
    ],
    "source" : {
    "modules" : [
      "http_ssl_module",
      "http_geoip_module",
      "http_realip_module",
      "http_stub_status_module",
      "http_gzip_static_module"
    ]
    }
  }
}
```

Test
---

### Install test dependencies

`bundle`

### test

`kitchen test`

#### Platforms for test-kitchen

```
 $ kitchen list
Instance               Driver   Provisioner  Last Action
default-ubuntu-1204    Vagrant  ChefSolo     <Not Created>
default-centos-64      Vagrant  ChefSolo     <Not Created>
rbenv-ubuntu-1204      Vagrant  ChefSolo     <Not Created>
rbenv-centos-64        Vagrant  ChefSolo     <Not Created>
ngx-mruby-ubuntu-1204  Vagrant  ChefSolo     <Not Created>
ngx-mruby-centos-64    Vagrant  ChefSolo     <Not Created>
mod-mruby-ubuntu-1204  Vagrant  ChefSolo     <Not Created>
mod-mruby-centos-64    Vagrant  ChefSolo     <Not Created>
```

You can test specific recipe.

```
kitchen converge mod-mruby
```

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

