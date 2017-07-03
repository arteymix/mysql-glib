/*
 * This file is part of Mysql-GLib.
 *
 * Mysql-GLib is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Mysql-GLib is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Mysql-GLib.  If not, see <http://www.gnu.org/licenses/>.
 */

public class GMysql.Database : GLib.Object, GLib.Initable {

	private Mysql.Database database;

	public string hostname { construct; get; default = "localhost"; }

	public uint port { construct; get; default = 3306; }

	public Database (string hostname, uint16 port) throws Error {
		base (hostname: hostname, port: port);
		init ();
	}

	construct {
		database = new Mysql.Database ();
	}

	public bool init (Cancellable? cancellable = null) throws Error {
		database.options (Mysql.Option.OPT_RECONNECT, "1");
		if (!database.real_connect (hostname, null, null, null, port)) {
			throw new DatabaseError.FAILED (database.error ());
		}
		return true;
	}

	public unowned Mysql.Database get_mysql_database () {
		return database;
	}

	private void _handle_return_code (int rc) throws DatabaseError {
		if (rc != 0)  {
			throw new DatabaseError.FAILED (database.error ());
		}
	}

	public void ping () throws DatabaseError {
		_handle_return_code (database.ping ());
	}

	public Result? query_valist (string statement, va_list list) throws DatabaseError {
		var statement_builder = new GLib.StringBuilder ();
		var statement_offset = 0;

		for (var str = list.arg<string?> (); str != null; str = list.arg<string?> ()) {
			var pos = statement.index_of_char ('?', statement_offset);

			if (pos == -1) {
				throw new DatabaseError.FAILED ("Could not interpolate, no more '?' character to substitute.");
			}

			statement_builder.append (statement[statement_offset:pos]);

			var str_dest     = (string) new uint8[2 * str.length + 1];
			var str_dest_len = (long) database.real_escape_string (str_dest, str, str.length);

			if (str_dest_len == -1) {
				throw new DatabaseError.FAILED ("Could not escape the value for position '%u'.", pos);
			}

			if (bool.try_parse (str_dest) || int64.try_parse (str_dest) || double.try_parse (str_dest)) {
				statement_builder.append_len (str_dest, str_dest_len);
			} else {
				statement_builder.append_c ('\'');
				statement_builder.append_len (str_dest, str_dest_len);
				statement_builder.append_c ('\'');
			}

			statement_offset = pos + 1; // just right after the '?'
		}

		/* fill the rest of the statement as-is */
		statement_builder.append (statement[statement_offset:statement.length]);

		_handle_return_code (database.real_query (statement_builder.str, statement_builder.len));

		var result = database.use_result ();

		if (result == null) {
			throw new DatabaseError.FAILED (database.error ());
		}

		return new Result (this, (owned) result);
	}

	public Result? query (string statement, ...) throws DatabaseError {
		return query_valist (statement, va_list ());
	}
}
