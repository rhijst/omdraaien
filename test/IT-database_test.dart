import 'package:omdraaien/DB/Connection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_client/mysql_client.dart';

void main() {
  group('Database Integration Test', () {
    late MySQLConnection connection;

    // Setup function runs before the test starts
    // Get connection settings
    setUp(() async {
      connection = await DBConnection.setupConnection();
    });

    // Teardown function starts after the test is executed
    // Close connection
    tearDown(() async {
      await connection.close();
    });

    test('Connection Test', () async {
      await connection.connect();
      final results = await connection.execute('SELECT 1');
      expect(results.isNotEmpty, true);
    });
  });
}
