mysql_glib_sources = [
    'gmysql-database.vala',
    'gmysql-database-error.vala',
    'gmysql-result.vala',
    'gmysql-result-iter.vala',
    'gmysql-row.vala']

mysql_glib_lib = library('mysql-glib', mysql_glib_sources,
                         dependencies: [glib_dep, gobject_dep, gio_dep, mysql_dep])

mysql_glib_dep = declare_dependency(include_directories: include_directories('.'),
                                    link_with: mysql_glib_lib)
