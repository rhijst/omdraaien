import 'package:flutter/material.dart';

import 'routes/AddBed.dart';
import 'routes/HomeWerknemer.dart';
import 'routes/HomePatient.dart';
import 'routes/login.dart';

import 'models/Patient.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init();
}

Future<void> init() async {
  bool isLogged = await Auth.isLogged();
  String initialRoute = isLogged ? '/homePatient' : '/login';
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bed omdraaien',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginRoute(),
        '/homePatient': (context) => const HomePatient(),
        '/homeWerknemer': (context) => const HomeWerknemer(),
        '/addBed': (context) => AddBed(),
      },
    );
  }
}

class Auth {
  static Future<bool> isLogged() async {
    Patient? retrievedPatient = await Patient.retrievePatient();

    if (retrievedPatient != null) {
      return true;
    } else {
      return false;
    }
  }
}

  // Flex(direction: Axis.vertical, children: [
  //   Container(
  //     padding: const EdgeInsets.all(15),
  //     child: const Text(
  //       "Er is op het moment nog geen connectie",
  //       style: TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 16,
  //       ),
  //       softWrap: true,
  //     ),
  //   ),
  // ]),