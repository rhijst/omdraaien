import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:omdraaien/DB/DAL/DraaiDAL.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/Draai.dart';
import '../models/Patient.dart';

class HomePatient extends StatelessWidget {
  const HomePatient({Key? key});

  @override
  Widget build(BuildContext context) {
    BT bt = BT();

    return FutureBuilder<Patient?>(
      future: Patient.retrievePatient(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while retrieving patient data
          return Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Show an error message if there was an error retrieving patient data
          return Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: const Center(child: Text('Error retrieving patient data')),
          );
        } else {
          final Patient? patient = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.bed_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Uit loggen
                    // Deze functie is alleen voor het testen. Een patient heeft geen mogelijkheid om uit te loggen.
                    // /////////////////////////////////
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Uitloggen?'),
                          content:
                              const Text('Weet u zeker dat u wilt uitloggen?'),
                          actions: [
                            TextButton(
                              child: const Text('Annuleren'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Uitloggen'),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (route) => false);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Patient details
                    Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Patient details
                        const Text("Patient details",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Naam: ${patient?.naam}"),
                        Text("Email: ${patient?.email}"),
                        // Bed details
                        const Text("Bed details",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Bed: ${patient?.bed?.bed ?? 'N/A'}"),
                        Text("Afmetingen: ${patient?.bed?.afmeting ?? 'N/A'}"),
                        Text("afdeling: ${patient?.bed?.kamer ?? 'N/A'}"),
                      ],
                    ),

                    const Divider(),

                    // Bluetooth widget
                    BluetoothWidget(bt: bt),

                    const Divider(),

                    // Stop knop
                    Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Stop',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Klik hier om te stoppen met draaien.'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          // Container(child: ,padding: EdgeInsets,),
                          onPressed: () {
                            bt.sendMessage("s");
                          },
                          child: Text(bt._isConnected
                              ? 'Er zit geen verbinding'
                              : 'STOP'),
                        ),
                      ],
                    ),

                    const Divider(),

                    // Buttons
                    Flex(
                      direction: Axis.vertical,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text(
                            "Omdraaien.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: const Text(
                            "Klik op de knop om het bed te roteren naar een kant.",
                          ),
                        ),
                        Buttons(bt: bt, p: patient),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class Buttons extends StatelessWidget {
  final BT bt;
  final Patient? p;
  const Buttons({Key? key, required this.bt, this.p});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // Links
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 16, 126, 216),
          ),
          onPressed: () {
            // Add draai to DB
            Draai d = Draai();
            d.kant = "Links";
            DraaiDAL dDAL = DraaiDAL();
            if (p?.bed != null) {
              dDAL.insert(p!.bed, d);
            }

            bt.sendMessage("l");
          },
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Text(
              // 'Links',
              'Omhoog',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        // Rechts
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 16, 126, 216),
          ),
          onPressed: () {
            // Add draai to DB
            Draai d = Draai();
            d.kant = "Rechts";
            DraaiDAL dDAL = DraaiDAL();

            if (p?.bed != null) {
              dDAL.insert(p!.bed, d);
            }
            bt.sendMessage("r");
          },
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Text(
              // 'Rechts',
              'Omlaag',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        )
      ],
    );
  }
}

class BT {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;
  bool _isConnected = false;

  Future<void> sendMessage(String message) async {
    if (_isConnected && _connection != null) {
      Uint8List data = Uint8List.fromList(utf8.encode(message + "\r\n"));
      _connection!.output.add(data);
      await _connection!.output.allSent;
    }
  }
}

class BluetoothWidget extends StatefulWidget {
  BluetoothWidget({Key? key, required this.bt});

  final BT bt;

  @override
  _BluetoothWidgetState createState() => _BluetoothWidgetState();
}

class _BluetoothWidgetState extends State<BluetoothWidget> {
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    bool? isEnabled = await widget.bt._bluetooth.isEnabled;
    if (!isEnabled!) {
      await widget.bt._bluetooth.requestEnable();
    }
    widget.bt._bluetooth.onStateChanged().listen((BluetoothState state) async {
      if (state == BluetoothState.STATE_ON) {
        await requestBluetoothPermission();
        _connectToDevice();
      }
    });
  }

  // Connect to a device
  void _connectToDevice() async {
    setState(() {
      _isConnecting = true;
    });

    await requestBluetoothPermission();
    List<BluetoothDevice> devices = [];
    try {
      devices = await widget.bt._bluetooth.getBondedDevices();
    } catch (e) {
      print('Error: $e');
    }
    if (devices.isNotEmpty) {
      for (BluetoothDevice device in devices) {
        if (device.name!.contains('HC-05')) {
          try {
            BluetoothConnection connection =
                await BluetoothConnection.toAddress(device.address);
            print('Connected to: ${device.name}');
            setState(() {
              widget.bt._isConnected = true;
              widget.bt._connection = connection;
              _isConnecting = false;
            });
          } catch (e) {
            print('Error: $e');
          }
          break;
        }
      }
    }
  }

  // Request the Bluetooth permission
  Future<void> requestBluetoothPermission() async {
    PermissionStatus status = await Permission.bluetooth.request();
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  void _disconnect() async {
    await widget.bt._connection?.close();
    setState(() {
      widget.bt._isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Verbinding status',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isConnecting
              ? 'Verbinding wordt gemaakt...'
              : (widget.bt._isConnected
                  ? 'Verbonden met bed'
                  : 'Klik op verbinden om connectie te maken.'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: widget.bt._isConnected ? _disconnect : _connectToDevice,
          child: Text(
              widget.bt._isConnected ? 'Verbreek de verbinding' : 'Verbinden'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
