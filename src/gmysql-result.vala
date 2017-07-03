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

public class GMysql.Result : Object {

	private         Mysql.Result  result;
	private unowned Mysql.Field[] fields;

	public Database database { construct; get; }

	internal Result (Database database, owned Mysql.Result result) {
		base (database: database);
		this.result = (owned) result;
		this.fields = this.result.fetch_fields ();
	}

	public unowned Mysql.Result get_mysql_result () {
		return result;
	}

	public unowned Mysql.Field[] get_mysql_fields () {
		return fields;
	}

	public ResultIter iterator () {
		return new ResultIter (this);
	}
}
