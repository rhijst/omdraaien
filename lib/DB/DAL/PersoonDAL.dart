import 'package:mysql_client/mysql_client.dart';
import '../../models/Bed.dart';
import '../../models/Draai.dart';
import '../../models/Patient.dart';
import '../../models/Persoon.dart';
import '../../models/Werknemer.dart';
import '../connection.dart';

class PersoonDAL {
  Future<bool> login(Persoon p) async {
    MySQLConnection conn = await DBConnection.setupConnection();
    String pas = "";
    p.email = "";

    try {
      // Create connection
      conn = await DBConnection.setupConnection();
      await conn.connect();

      // get user info with current username
      var result = await conn.execute(
          "SELECT * FROM Gebruikers WHERE naam = :naam", {"naam": p.naam});

      // If there is no record return false
      if (result.numOfRows != 1) {
        await conn.close();
        return false;
      }

      final row = result.rows.first;
      pas = row.colByName("wachtwoord") ?? "";

      // Return false if password is false
      if (pas != p.wachtwoord) {
        p.wachtwoord = "false";
        await conn.close();
        return false;
      }

      await conn.close();
      return true;
    } catch (e) {
      print(e);
      try {
        await conn.close();
      } catch (e) {
        print(e);
      }
    }
    return true;
  }

  Future<T> readSinglePerson<T extends Persoon>(String name) async {
    MySQLConnection conn = await DBConnection.setupConnection();

    try {
      // Create connection
      conn = await DBConnection.setupConnection();
      await conn.connect();

      // Get user info with current username
      var result = await conn.execute(
          "SELECT * FROM Gebruikers g JOIN bedden b ON g.bed = b.bed WHERE naam = :naam",
          {"naam": name});

      // Get data from the row
      final row = result.rows.first;

      // Check if the row has "personeelsNummer" to see if its a patient
      if (row.colByName("personeelsNummer") != null) {
        // Create Werknemer object
        Werknemer w = Werknemer(row.colByName("naam") ?? "");
        w.personeelsNummer = row.colByName("personeelsnummer") ?? "";
        w.geboortedatum = DateTime.parse(row.colByName("geboortedatum") ?? "");
        w.email = row.colByName("email") ?? "";
        w.persoonlijkeBegelijder = int.parse(row.colByName("lengte") ?? "");
        return w as T; // Return the Werknemer object as type T
      } else {
        // Create patient object
        Patient p = Patient(row.colByName("naam") ?? "");
        p.gewicht = int.parse(row.colByName("gewicht") ?? "");
        p.lengte = int.parse(row.colByName("lengte") ?? "");
        if (row.colByName("geboortedatum") != null) {
          p.geboortedatum =
              DateTime.parse(row.colByName("geboortedatum") ?? "");
        }
        p.email = row.colByName("email") ?? "";
        p.persoonlijkeBegelijder = int.parse(row.colByName("lengte") ?? "");

        // Create bed object
        Bed b = Bed();
        b.bed = int.parse(row.colByName("bed") ?? "");
        b.afmeting = row.colByName("afmeting") ?? "";
        b.maxGewicht = int.parse(row.colByName("maxGewicht") ?? "");
        b.locatie = row.colByName("locatie") ?? "";
        b.kamer = row.colByName("kamer") ?? "";

        p.bed = b;

        return p as T; // Return the Patient object as type T
      }
    } catch (e) {
      print(e);
      return Persoon("false")
          as T; // Return a default Persoon object as type T in case of an error
    } finally {
      try {
        await conn.close();
      } catch (e) {
        print(e);
      }
    }
  }

  // Read function
  Future<List<Persoon>> read() async {
    MySQLConnection conn = await DBConnection.setupConnection();
    List<Persoon> lp = [];

    try {
      await conn.connect();
      var result = await conn.execute(
          "SELECT * FROM Gebruikers g LEFT JOIN bedden b ON g.bed = b.bed LEFT JOIN draaien d ON b.bed = d.bed");

      for (final row in result.rows) {
        // Create bed object
        Bed b = Bed();
        b.bed = int.parse(row.colByName("bed") ?? "");
        b.afmeting = row.colByName("afmeting") ?? "";
        b.maxGewicht = int.parse(row.colByName("maxGewicht") ?? "");
        b.locatie = row.colByName("locatie") ?? "";
        b.kamer = row.colByName("kamer") ?? "";

        // Create draai/turn object
        Draai d = Draai();
        d.draai = int.parse(row.colByName("draai")!);
        d.moment = DateTime.parse(row.colByName("moment")!);
        d.kant = row.colByName("kant")!;
        d.bed = b;

        // Create persoon object
        Persoon p;
        if (row.colByName("personeelsNummer") != null) {
          Werknemer w = Werknemer(row.colByName("naam") ?? "");
          w.personeelsNummer = row.colByName("personeelsnummer") ?? "";
          w.wachtwoord = row.colByName("wachtwoord") ?? "";
          p = w;
        } else {
          Patient pat = Patient(row.colByName("naam") ?? "");
          pat.gewicht = int.parse(row.colByName("gewicht") ?? "");
          pat.lengte = int.parse(row.colByName("lengte") ?? "");
          p = pat;
        }
        p.geboortedatum = DateTime.parse(row.colByName("geboortedatum") ?? "");
        p.email = row.colByName("email") ?? "";
        p.persoonlijkeBegelijder =
            int.parse(row.colByName("persoonlijkeBegelijder") ?? "");

        // Add person to the list
        lp.add(p);
      }
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
    return lp;
  }
}
