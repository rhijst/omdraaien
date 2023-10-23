import 'package:flutter_test/flutter_test.dart';
import 'package:omdraaien/models/Werknemer.dart';

void main() {
  group('Werknemer class', () {
    test('Setting and getting personeelsNummer', () {
      final werknemer = Werknemer('');
      werknemer.personeelsNummer = '12345';
      expect(werknemer.personeelsNummer, '12345');
    });
  });
}
