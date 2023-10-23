import 'package:flutter_test/flutter_test.dart';
import 'package:omdraaien/models/Persoon.dart';

void main() {
  group('Persoon class', () {
    test('Setting and getting naam', () {
      final persoon = Persoon('');
      persoon.naam = 'John Doe';
      expect(persoon.naam, 'John Doe');
    });

    test('Setting and getting geboortedatum', () {
      final persoon = Persoon('');
      final geboortedatum = DateTime(1990, 10, 15);
      persoon.geboortedatum = geboortedatum;
      expect(persoon.geboortedatum, geboortedatum);
    });

    test('Setting and getting wachtwoord', () {
      final persoon = Persoon('');
      persoon.wachtwoord = 'password123';
      expect(persoon.wachtwoord, 'password123');
    });

    test('Setting and getting email', () {
      final persoon = Persoon('');
      persoon.email = 'john.doe@example.com';
      expect(persoon.email, 'john.doe@example.com');
    });

    test('Setting and getting persoonlijkeBegelijder', () {
      final persoon = Persoon('');
      persoon.persoonlijkeBegelijder = 12345;
      expect(persoon.persoonlijkeBegelijder, 12345);
    });
  });
}
