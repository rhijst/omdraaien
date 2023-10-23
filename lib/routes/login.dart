import 'package:flutter/material.dart';
import '../DB/DAL/PersoonDAL.dart';
import '../models/Patient.dart';
import '../models/Persoon.dart';
import '../models/Werknemer.dart';
import '../util/util.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final loginKey = GlobalKey<FormState>();
    final nameField = TextEditingController();
    final passField = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Form(
          key: loginKey,
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserInputField(TECNameField: nameField),
                PassInputField2(TECPassword: passField),
                TextButton(
                  child: const Text('Inloggen'),
                  onPressed: () {
                    // If the fields are not correctly validated
                    if (!loginKey.currentState!.validate()) {
                      return;
                    }

                    // login
                    login(nameField, passField, context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(TextEditingController nameField, TextEditingController passField,
      BuildContext context) {
    Persoon p = Persoon(nameField.text.toLowerCase());
    p.wachtwoord = passField.text;

    // If login credentials are correct
    checkLogin(p).then((result) {
      // Give a message to the user
      if (!result) {
        const snackBar = SnackBar(
          content: Text(
              // 'Er is iets fout gegaan. Probeer het opnieuw'),
              'Het lijkt er op dat de ingevoerde info niet correct is probeer het opnieuw.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // Give a message to the user
        const snackBar = SnackBar(
          content: Text('U bent ingelogd'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Get the user object
        PersoonDAL pDAL = PersoonDAL();
        pDAL.readSinglePerson(p.naam).then((person) {
          if (person is Werknemer) {
            // Nagivate the worker to there homepage
            Navigator.pushReplacementNamed(context, '/homeWerknemer');
          } else if (person is Patient) {
            // Save patient in local storage
            person.savePatient();

            // Nagivate the patient to there home page
            Navigator.pushReplacementNamed(context, '/homePatient');
          }
        });
      }
    });

    // Give a message to the user
    const snackBar = SnackBar(
      content: Text('Aan het inloggen...'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> checkLogin(Persoon p) async {
    // Create person object
    p.wachtwoord = Util.encryptPassword(p.wachtwoord);

    // Check login
    PersoonDAL pDAL = PersoonDAL();
    bool logedin = await pDAL.login(p);

    return logedin;
  }
}

// First input field username
class UserInputField extends StatelessWidget {
  const UserInputField({super.key, required this.TECNameField});
  final TextEditingController TECNameField;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      // Name field
      child: TextFormField(
        controller: TECNameField,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Vul hier uw volledige naam in',
          labelText: 'Naam *',
        ),
        onSaved: (String? value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            return null;
          } else {
            return "Vul hier uw naam in";
          }
        },
      ),
    );
  }
}

// The input field password
// This Widget is stateful so the user can change the security(IF the characters are hidden while typing)
class PassInputField2 extends StatefulWidget {
  const PassInputField2({super.key, required this.TECPassword});
  final TextEditingController TECPassword;

  @override
  _PassInputField2 createState() => _PassInputField2(TECPassword);
}

class _PassInputField2 extends State<PassInputField2> {
  _PassInputField2(this.TECPassword) {
    TECPassword = TECPassword;
  }
  TextEditingController TECPassword;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: TECPassword,
        obscureText: _isObscure,
        decoration: InputDecoration(
          icon: const Icon(Icons.lock),
          hintText: 'Vul hier uw wachtwoord in',
          labelText: 'Wachtwoord *',
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        ),
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            return null;
          } else {
            return "Vul hier uw wachtwoord in";
          }
        },
      ),
    );
  }
}