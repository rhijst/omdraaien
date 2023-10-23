import 'package:mysql_client/mysql_client.dart';

import '../../models/Bed.dart';
import '../../models/Draai.dart';
import '../Connection.dart';

class DraaiDAL {
  // Read function
  Future<List<Draai>> read(Bed bed) async {
    MySQLConnection conn = await DBConnection.setupConnection();
    List<Draai> lDraaien = [];

    try {
      await conn.connect();
      var result = await conn.execute("SELECT * FROM draaien WHERE bed = :bed",{"bed":bed.bed});

      for (final row in result.rows) {
        // Create draai object
        Draai d = Draai();
        d.moment = DateTime.parse(row.colByName("moment") ?? "");
        d.kant = row.colByName("kant") ?? "";

        // Add draai to the list
        lDraaien.add(d);
      }

      // Try to close connection
      try {
        await conn.close();
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
      try {
        await conn.close();
      } catch (e) {
        print(e);
      }
    }
    return lDraaien;
  }

  Future<void> insert(Bed bed,Draai draai) async {
    MySQLConnection conn = await DBConnection.setupConnection();

    try {
      await conn.connect();

      // Get the current moment and kant values from the Bed object
      DateTime moment = DateTime
          .now(); // Replace this with the appropriate value from the Bed object

      await conn.execute(
          "INSERT INTO draaien (moment, kant, bed) VALUES (:moment, :kant, :bed)",
          {"moment": moment, "kant": draai.kant, "bed": bed.bed});

      // Try to close connection
      try {
        await conn.close();
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
      try {
        await conn.close();
      } catch (e) {
        print(e);
      }
    }
  }
}
