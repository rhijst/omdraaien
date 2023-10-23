import 'package:flutter_test/flutter_test.dart';
import 'package:omdraaien/models/Bed.dart';
import 'package:omdraaien/models/Draai.dart';

void main() {
  group('Bed class', () {
    test('Setting and getting bed number', () {
      final bed = Bed();
      bed.bed = 1;
      expect(bed.bed, 1);
    });

    test('Setting and getting afmeting', () {
      final bed = Bed();
      bed.afmeting = '190x90';
      expect(bed.afmeting, '190x90');
    });

    test('Setting and getting max gewicht', () {
      final bed = Bed();
      bed.maxGewicht = 200;
      expect(bed.maxGewicht, 200);
    });

    test('Setting and getting locatie', () {
      final bed = Bed();
      bed.locatie = 'Slaapkamer 1';
      expect(bed.locatie, 'Slaapkamer 1');
    });

    test('Setting and getting kamer', () {
      final bed = Bed();
      bed.kamer = 'Kamer 1';
      expect(bed.kamer, 'Kamer 1');
    });

    test('Setting and getting draaien', () {
      final bed = Bed();
      final draai1 = Draai();
      final draai2 = Draai();
      bed.draaien = [draai1, draai2];
      expect(bed.draaien.length, 2);
      expect(bed.draaien.contains(draai1), true);
      expect(bed.draaien.contains(draai2), true);
    });
  });
}
