import 'package:mysql_client/mysql_client.dart';

import '../../models/Bed.dart';
import '../../models/Patient.dart';
import '../connection.dart';

class BedDAL {
  // Read function
  Future<List<Bed>> read() async {
    MySQLConnection conn = await DBConnection.setupConnection();
    List<Bed> lBeds = [];

    try {
      await conn.connect();
      var result = await conn.execute("SELECT * FROM bedden");

      for (final row in result.rows) {
        // Create bed object
        Bed b = Bed();
        b.bed = int.parse(row.colByName("bed") ?? "");
        b.afmeting = row.colByName("afmeting") ?? "";
        b.maxGewicht = int.parse(row.colByName("maxGewicht") ?? "");
        b.locatie = row.colByName("locatie") ?? "";
        b.kamer = row.colByName("kamer") ?? "";

        // Add bed to the list
        lBeds.add(b);
      }
    } catch (e) {
      print(e);
      try {
        try {
          await conn.close();
        } catch (e) {
          print(e);
        }
      } catch (e) {
        print(e);
      }
    }
    return lBeds;
  }

  // Read a single bed
  Future<Bed> readSingle(Patient p) async {
    MySQLConnection conn = await DBConnection.setupConnection();
    Bed bed = Bed();

    try {
      await conn.connect();
      var result = await conn
          .execute("SELECT * FROM bedden WHERE bed = :bed;", {"bed": p.bed});

      // If there is no record return false
      if (result.numOfRows != 1) {
        return bed;
      }

      // Fill bed object
      final row = result.rows.first;
      bed.bed = int.parse(row.colByName("bed") ?? "-1");
      bed.afmeting = row.colByName("afmeting") ?? "";
      bed.kamer = row.colByName("kamer") ?? "";
      bed.locatie = row.colByName("locatie") ?? "-1";
      bed.maxGewicht = int.parse(row.colByName("maxGewicht") ?? "");

      await conn.close();
    } catch (e) {
      try {
        await conn.close();
      } catch (e) {
        print(e);
      }
      print(e);
    }
    return bed;
  }

  // add a single bed
  void add(Bed b) async {
    MySQLConnection conn = await DBConnection.setupConnection();

    try {
      await conn.connect();
      var result = await conn.execute(
          "INSERT INTO bedden (afmeting, maxGewicht, locatie, kamer) VALUES(:afmeting, :maxGewicht, :locatie, :kamer);",
          {
            "afmeting": b.afmeting,
            "maxGewicht": b.maxGewicht,
            "locatie": b.locatie,
            "kamer": b.kamer
          });
      await conn.close();
    } catch (e) {
      await conn.close();
      print(e);
    }
  }

  // Delete a single bed
  void delete(Bed b) async {
    MySQLConnection conn = await DBConnection.setupConnection();

    try {
      await conn.connect();
      var result = await conn
          .execute("DELETE FROM bedden WHERE bed = :bed;", {"bed": b.bed});

      await conn.close();
    } catch (e) {
      try {
        await conn.close();
      } catch (e) {
        print(e);
      }
      print(e);
    }
  }
}
