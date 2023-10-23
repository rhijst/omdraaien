import 'package:flutter_test/flutter_test.dart';
import 'package:omdraaien/models/Bed.dart';
import 'package:omdraaien/models/Draai.dart';

void main() {
  group('Draai class', () {
    test('Setting and getting draai number', () {
      final draai = Draai();
      draai.draai = 1;
      expect(draai.draai, 1);
    });

    test('Setting and getting momenten', () {
      final draai = Draai();
      final moment = DateTime.now();
      draai.moment = moment;
      expect(draai.moment, moment);
    });

    test('Setting and getting kant', () {
      final draai = Draai();
      draai.kant = 'Links';
      expect(draai.kant, 'Links');
    });

    test('Setting and getting bed', () {
      final draai = Draai();
      final bed = Bed();
      draai.bed = bed;
      expect(draai.bed, bed);
    });
  });
}
