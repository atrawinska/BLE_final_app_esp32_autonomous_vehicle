import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

//constants
const String esp_name = "ESP32";
//app
void main() async {

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State <MyApp> createState() =>  MyAppState();
}

class MyAppState extends State<MyApp> {
  StartBlue startBlue = StartBlue();

  @override
  void initState() {
    super.initState();
    startBlue.scanBlueDevices(); // Start scanning in initState
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StreamBuilder<List<ScanResult>>(
            stream: FlutterBluePlus.scanResults,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while scanning
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No devices found');
              }

              final devices = snapshot.data!;

              return ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  var deviceName = devices[index].device.platformName.isNotEmpty
                      ? devices[index].device.platformName
                      : 'Unknown';

                  return ListTile(
                    title: Text(deviceName),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}






class StartBlue {
  List<ScanResult> devices = [];
  Function()? onDevicesUpdated; // Callback to notify UI updates



  Future<void> scanBlueDevices() async {

  if (Platform.isAndroid) {
    await FlutterBluePlus.turnOn(); // Request the user to turn on Bluetooth
}


    // Listen to scan results
    var subscription = FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty) {
        devices.clear(); // Clear to avoid duplicates
        devices.addAll(results);

        if (onDevicesUpdated != null) {
          onDevicesUpdated!(); // Call the callback when new data is available
        }
      }
    }, onError: (e) => print(e));

    // Cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

    // Wait for Bluetooth enabled & permission granted
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

    // Start scanning with a timeout
    await FlutterBluePlus.startScan(
      withNames: [esp_name], // Match any of the specified names
      timeout: Duration(seconds: 80),
    );

    // Wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }
}
