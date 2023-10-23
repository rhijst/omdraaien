import 'package:mysql_client/mysql_client.dart';

class DBConnection {
  static Future<MySQLConnection> setupConnection() async {
    final conn = await MySQLConnection.createConnection(
      host: 'DB_NAME',
      port: 0000,
      userName: 'DB_USERNAME',
      password: 'DB_PASSWORD',
      databaseName: 'DB_NAME',
    );

    return conn;
  }

  test() async {
    // create connection
    final conn = await MySQLConnection.createConnection(
      host: 'DB_NAME',
      port: 0000,
      userName: 'DB_USERNAME',
      password: 'DB_PASSWORD',
      databaseName: 'DB_NAME',
    );
    await conn.connect();

    // make query
    var result = await conn.execute("SELECT * FROM Gebruikers");

    // print some result data
    print(result.numOfColumns);
    print(result.numOfRows);
    print(result.lastInsertID);
    print(result.affectedRows);

    // print query result
    for (final row in result.rows) {
      print(row.assoc());
    }

    // close all connections
    await conn.close();
  }
}
