// ignore_for_file: unnecessary_getters_setters
import 'package:omdraaien/models/Draai.dart';

class Bed {
  late int _bed;
  late String _afmeting;
  late int _maxGewicht;
  late String _locatie;
  late String _kamer;
  late List<Draai> _draaien = [];

  int get bed => _bed;

  set bed(int bed) {
    _bed = bed;
  }

  String get afmeting => _afmeting;

  set afmeting(String newAfmeting) {
    _afmeting = newAfmeting;
  }

  int get maxGewicht => _maxGewicht;

  set maxGewicht(int newMaxGewicht) {
    _maxGewicht = newMaxGewicht;
  }

  String get locatie => _locatie;

  set locatie(String newLocatie) {
    _locatie = newLocatie;
  }

  String get kamer => _kamer;

  set kamer(String newKamer) {
    _kamer = newKamer;
  }

  List<Draai> get draaien => _draaien;

  set draaien(List<Draai> value) {
    _draaien = value;
  }

  // Convert the bed object to a JSON string
  Map<String, dynamic> toJson() {
    return {
      'bed': _bed,
      'afmeting': _afmeting,
      'maxGewicht': _maxGewicht,
      'locatie': _locatie,
      'kamer': _kamer,
    };
  }
}
