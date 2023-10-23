import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/Patient.dart';

class HomePatient extends StatelessWidget {
  const HomePatient({Key? key}) : super(key: key);

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
                    // Navigator.pushNamed(context, "/bt");
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
                        Text("Bed: ${patient?.bed.bed}"),
                        Text("afmetingen: ${patient?.bed.afmeting}"),
                        Text("afmetingen: ${patient?.bed.kamer}"),
                      ],
                    ),

                    const Divider(),

                    // Bluetooth widget
                    BluetoothWidget(bt: bt),

                    const Divider(),

                    // Buttons
                    Flex(
                      direction: Axis.vertical,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text(
                            "Klik op de knop om het bed te roteren naar een kant.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Buttons(bt: bt),
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

  const Buttons({Key? key, required this.bt}) : super(key: key);

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
            bt.sendMessage("l");
          },
          child: Container(
            padding: const EdgeInsets.all(40),
            child: const Text(
              'Links',
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
            bt.sendMessage("r");
          },
          child: Container(
            padding: const EdgeInsets.all(40),
            child: const Text('Rechts',
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
    if (_isConnected) {
      Uint8List data = Uint8List.fromList(utf8.encode(message + "\r\n"));
      _connection?.output.add(data);
      await _connection?.output.allSent;
    }
  }
}

class BluetoothWidget extends StatefulWidget {
  final BT bt;

  const BluetoothWidget({Key? key, required this.bt}) : super(key: key);

  @override
  _BluetoothWidgetState createState() => _BluetoothWidgetState();
}

class _BluetoothWidgetState extends State<BluetoothWidget> {
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
    await requestBluetoothPermission();
    List<BluetoothDevice> devices = [];
    try {
      // TO DO: Op het moment moet er handmatig in de instelling geaccepteerd worden. Waarom?
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
            });
            // await Future.delayed(const Duration(seconds: 5));
            setState(() {
              widget.bt._isConnected = true;
              // widget.bt._connection = connection;
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
      children: <Widget>[
        Text(
          widget.bt._isConnected ? 'Verbonden' : 'Nog niet verbonden',
          style: const TextStyle(fontSize: 24.0),
        ),
        const SizedBox(height: 8),
        Text('Text when loading.'),
        const SizedBox(height: 16),
        ElevatedButton(
            onPressed: widget.bt._isConnected ? _disconnect : _connectToDevice,
            child: Text(widget.bt._isConnected
                ? 'Verbreek de verbinding'
                : 'Verbinden')),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: widget.bt._isConnected
              ? () => widget.bt.sendMessage('_Hello world')
              : null,
          child: const Text('Test bericht'),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
