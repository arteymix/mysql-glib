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

public class GMysql.ResultIter : Object {

	private Row? current_row;

	public Result result { construct; get; }

	internal ResultIter (Result result) {
		base (result: result);
		this.current_row = null;
	}

	public new Row? get () {
		return current_row;
	}

	public bool next () throws DatabaseError {
		var row = result.get_mysql_result ().fetch_row ();
		if (row == null) {
			if (result.get_mysql_result ().eof ()) {
				return false;
			} else {
				throw new DatabaseError.FAILED (result.database.get_mysql_database ().error ());
			}
		}
		current_row = new Row (result, row);
		return true;
	}
}
