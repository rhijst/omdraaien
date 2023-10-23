import 'package:flutter_test/flutter_test.dart';
import 'package:omdraaien/models/Patient.dart';
import 'package:omdraaien/models/Bed.dart';

void main() {
  group('Patient class', () {
    test('Setting and getting gewicht', () {
      final patient = Patient('');
      patient.gewicht = 70;
      expect(patient.gewicht, 70);
    });

    test('Setting and getting lengte', () {
      final patient = Patient('');
      patient.lengte = 170;
      expect(patient.lengte, 170);
    });

    test('Setting and getting bed', () {
      final patient = Patient('');
      final bed = Bed();
      patient.bed = bed;
      expect(patient.bed, bed);
    });
  });
}
