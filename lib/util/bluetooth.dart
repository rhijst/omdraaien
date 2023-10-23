import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class Bluetooth {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;
  bool _isConnected = false;

  @override
  void initState() {
    _initBluetooth();
  }

  void _initBluetooth() async {
    bool? isEnabled = await _bluetooth.isEnabled;
    if (!isEnabled!) {
      await _bluetooth.requestEnable();
    }
    _bluetooth.onStateChanged().listen((BluetoothState state) async {
      if (state == BluetoothState.STATE_ON) {
        await requestBluetoothPermission(); // Request permission when Bluetooth is enabled
        _connectToDevice();
      }
    });
  }

  void _connectToDevice() async {
    await requestBluetoothPermission();
    List<BluetoothDevice> devices = [];
    try {
      // TO DO: Op het moment moet er handmatig in de instelling geaccepteerd worden. Waarom?
      devices = await _bluetooth.getBondedDevices();
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
            _isConnected = true;
            _connection = connection;
          } catch (e) {
            print('Error: $e');
          }
          break;
        }
      }
    }
  }

  void disconnect() async {
    await _connection?.close();
    _isConnected = false;
  }

  void sendMessage(String message) async {
    Uint8List data = Uint8List.fromList(utf8.encode("$message\r\n"));
    _connection?.output.add(data);
    await _connection?.output.allSent;
  }

  // Function to request the Bluetooth permission
  Future<void> requestBluetoothPermission() async {
    PermissionStatus status = await Permission.bluetooth.request();
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }
}

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
//     _bluetooth.onStateChanged().listen((BluetoothState state) async {
//       if (state == BluetoothState.STATE_ON) {
//         await requestBluetoothPermission(); // Request permission when Bluetooth is enabled
//         _connectToDevice();
//       }
//     });
//   }

//   void _connectToDevice() async {
//     await requestBluetoothPermission();
//     List<BluetoothDevice> devices = [];
//     try {
//       // TO DO: Op het moment moet er handmatig in de instelling geaccepteerd worden. Waarom?
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
//       if (status.isPermanentlyDenied) {
//         openAppSettings();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
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
//               style: const TextStyle(fontSize: 24.0),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _isConnected ? _disconnect : _connectToDevice,
//               child: Text(_isConnected ? 'Disconnect' : 'Connect'),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed:
//                   _isConnected ? () => _sendMessage('_Hello world') : null,
//               child: const Text('Send Message'),
//             ),
//             const SizedBox(height: 16.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
