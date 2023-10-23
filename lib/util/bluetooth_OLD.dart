import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

// class BluetoothPage extends StatefulWidget {
//   @override
//   _BluetoothPageState createState() => _BluetoothPageState();
// }

// class _BluetoothPageState extends State<BluetoothPage> {
//   FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   BluetoothConnection? _connection;
//   bool _isConnected = false;

//   @override
//   void initState() {
//     super.initState();
//     _initBluetooth();
//   }

//   void _initBluetooth() async {
//     bool? isEnabled = await _bluetooth.isEnabled;
//     if (!isEnabled!) {
//       await _bluetooth.requestEnable();
//     }
//     _bluetooth.onStateChanged().listen((BluetoothState state) {
//       if (state == BluetoothState.STATE_ON) {
//         _connectToDevice();
//       }
//     });
//   }

//   void _connectToDevice() async {
//     List<BluetoothDevice> devices = [];
//     try {
//       devices = await _bluetooth.getBondedDevices();
//     } catch (e) {
//       print('Error: $e');
//     }
//     if (devices.isNotEmpty) {
//       for (BluetoothDevice device in devices) {
//         if (device.name!.contains('HC-05')) {
//           try {
//             BluetoothConnection connection =
//                 await BluetoothConnection.toAddress(device.address);
//             print('Connected to: ${device.name}');
//             setState(() {
//               _isConnected = true;
//               _connection = connection;
//             });
//           } catch (e) {
//             print('Error: $e');
//           }
//           break;
//         }
//       }
//     }
//   }

//   void _disconnect() async {
//     await _connection?.close();
//     setState(() {
//       _isConnected = false;
//     });
//   }

//   void _sendMessage(String message) async {
//     Uint8List data = Uint8List.fromList(utf8.encode(message + "\r\n"));
//     _connection?.output.add(data);
//     await _connection?.output.allSent;
//   }

//   // Function to request the Bluetooth permission
//   Future<void> requestBluetoothPermission() async {
//     PermissionStatus status = await Permission.bluetooth.request();
//     if (!status.isGranted) {
//       // Handle permission denied
//       // You can show a dialog explaining why the permission is needed and redirect the user to the app settings page
//       if (status.isPermanentlyDenied) {
//         openAppSettings();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Request the Bluetooth permission before building the UI
//     requestBluetoothPermission();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               _isConnected ? 'Connected' : 'Disconnected',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _isConnected ? _disconnect : _connectToDevice,
//               child: Text(_isConnected ? 'Disconnect' : 'Connect'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed:
//                   _isConnected ? () => _sendMessage('Hello world') : null,
//               child: Text('Send Message'),
//             ),
//             SizedBox(height: 16.0),
//             // ElevatedButton(
//             //   onPressed: checkPerm,
//             //   child: Text('check'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
