import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'Bed.dart';
import 'Persoon.dart';

class Patient extends Persoon {
  late int _gewicht;
  late int _lengte;
  late Bed _bed;

  // Constructor
  Patient(name) : super(name);

  int get gewicht => _gewicht;
  int get lengte => _lengte;
  Bed get bed => _bed;

  set gewicht(int gewicht) {
    _gewicht = gewicht;
  }

  set lengte(int lengte) {
    _lengte = lengte;
  }

  set bed(Bed bed) {
    _bed = bed;
  }

  // Save the patient object to shared preferences
  Future<void> savePatient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert patient object to JSON
    String patientJson = toJson();

    // Save the JSON to shared preferences
    await prefs.setString('patient', patientJson);
  }

  static void removePatient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('patient');
  }

  // get the patient object from shared preferences
  static Future<Patient?> retrievePatient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('patient');

    // Retrieve the JSON from shared preferences
    String? patientJson = prefs.getString('patient');

    if (patientJson != null) {
      // Change the JSON to patient object
      Map<String, dynamic> patientData = jsonDecode(patientJson);
      Patient patient = Patient(patientData['naam']);
      patient.gewicht = patientData['gewicht'];
      patient.lengte = patientData['lengte'];
      patient.email = patientData['email'];

      // Make a bed object (? null check)
      Map<String, dynamic>? bedData = patientData['bed'];
      if (bedData != null) {
        Bed bed = Bed();
        bed.bed = bedData['bed'];
        bed.afmeting = bedData['afmeting'];
        bed.maxGewicht = bedData['maxGewicht'];
        bed.locatie = bedData['locatie'];
        bed.kamer = bedData['kamer'];
        patient.bed = bed;
      }

      return patient;
    }

    return null;
  }

  // Converts the patient object to a JSON
  String toJson() {
    Map<String, dynamic> patientData = {
      'gewicht': _gewicht,
      'lengte': _lengte,
      'naam': super.naam,
      'email': super.email,
      'bed': _bed != null ? _bed.toJson() : null,
    };

    return jsonEncode(patientData);
  }
}
