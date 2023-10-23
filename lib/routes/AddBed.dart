import 'package:flutter/material.dart';

import '../DB/DAL/BedDAL.dart';
import '../models/Bed.dart';

class AddBed extends StatefulWidget {
  @override
  _AddBedState createState() => _AddBedState();
}

class _AddBedState extends State<AddBed> {
  final _formKey = GlobalKey<FormState>();
  Bed _newBed = Bed();

  // TO DO: Some field are required to fill in this form,
  // but are not required in the DB this need te be addressed
  // for the release version.(Nto for the prototype)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bed'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Afmeting',
                  hintText: "Formaat: 190x90",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vul de afmetingen van het bed in.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newBed.afmeting = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Max Gewicht',
                  hintText: "In KG Bijvoorbeeld: 90",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vul het gewicht in';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newBed.maxGewicht = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Locatie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vul de locatie in';
                  } else if (value.length > 75) {
                    return 'De locatie mag niet meer dan 75 characters lang zijn';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newBed.locatie = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kamer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'vul de kamer in.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newBed.kamer = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Call the method to add the bed to the database
                    BedDAL bd = BedDAL();
                    bd.add(_newBed);

                    // Navigate back to the previous page or any other desired page
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Bed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
