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

public class GMysql.Row : Object {

	public Result result { construct; get; }

	public string[] row { construct; get; }

	internal Row (Result result, string[] row) {
		base (result: result, row: row);
	}

	public new string? get (string column) {
		unowned Mysql.Field[] fields = result.get_mysql_fields ();
		for (var i = 0; i < fields.length; i++) {
			if (fields[i].name == column) {
				return row[i];
			}
		}
		critical ("No such column '%s'.", column);
		return null;
	}
}
