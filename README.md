# MySQL-GLib

Wrapper around MySQL C API

 - synchronous API with `mysql_use_result`
 - asynchronous API with `mysql_store_result`
 - GValue for binding statements and retrieving columns
 - blob streaming

This is meant to be an more convenient alternative to [GNOME-DB][gnomedb] if
you don't mind the vendor lock-in of MySQL.

[gnomedb]: http://www.gnome-db.org/

