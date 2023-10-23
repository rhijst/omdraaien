import 'package:shared_preferences/shared_preferences.dart';

import 'Persoon.dart';

class Werknemer extends Persoon {
  late String _personeelsNummer;

  // Constructor
  Werknemer(name) : super(name);

  String get personeelsNummer => _personeelsNummer;

  set personeelsNummer(String personeelsNummer) {
    _personeelsNummer = personeelsNummer;
  }
  
}
