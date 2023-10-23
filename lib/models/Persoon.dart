class Persoon {
  // Variables (Underscore makes it private)
  late String _naam;
  late DateTime _geboortedatum;
  late String _wachtwoord;
  late String _email;
  late int _persoonlijkeBegelijder;

  // Construtors
  Persoon(name) {
    _naam = name;
  }

  // getters
  String get naam => _naam;
  DateTime get geboortedatum => _geboortedatum;
  String get wachtwoord => _wachtwoord;
  String get email => _email;
  int get persoonlijkeBegelijder => _persoonlijkeBegelijder;

  // Setters
  set naam(String newNaam) {
    _naam = newNaam;
  }

  set geboortedatum(DateTime geboortedatum) {
    _geboortedatum = geboortedatum;
  }

  set wachtwoord(String wachtwoord) {
    _wachtwoord = wachtwoord;
  }

  set email(String email) {
    _email = email;
  }

  set persoonlijkeBegelijder(int persoonlijkeBegelijder) {
    _persoonlijkeBegelijder = persoonlijkeBegelijder;
  }
}
