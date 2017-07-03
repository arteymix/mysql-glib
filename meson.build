project('mysql-glib', 'c', 'vala')

glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
gio_dep = dependency('gio-2.0')

mysql_config = find_program('mysql_config')
mysql_vapi = meson.get_compiler('vala').find_library('mysql')
mysql_dep = declare_dependency(c_args: run_command([mysql_config, '--cflags']).stdout().split(),
                               link_args: run_command([mysql_config, '--libs']).stdout().split(),
                               dependencies: [mysql_vapi])

subdir('src')
