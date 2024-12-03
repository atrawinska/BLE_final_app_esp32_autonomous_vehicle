
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';



class ScanBlue {
  List<ScanResult> devices = [];
  Function()? onDevicesUpdated; // Callback to notify UI updates

  // StreamController for devices list updates
  final StreamController<List<ScanResult>> _devicesStreamController = StreamController<List<ScanResult>>.broadcast();

  // Getter for the stream
  Stream<List<ScanResult>> get devicesStream => _devicesStreamController.stream;

  Future turnOn() async {
    // First, check if Bluetooth is supported
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    // Handle Bluetooth on & off states
    var subscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // Bluetooth is on, you can start scanning, etc.
        print("Bluetooth is on");
      } else {
        // Handle cases where Bluetooth is off
        print("Bluetooth is off");
      }
    });

    // Turn on Bluetooth if we can (only for Android in this case)
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    // Cancel the subscription when Bluetooth state changes
    subscription.cancel();
  }

  Future<void> scanBlueDevices() async {
    turnOn();
    // Listen to scan results
    FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        // Add the updated list to the stream
        _devicesStreamController.add(devices);

        // Log the device info (optional)
        ScanResult r = results.last;
        print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
      }
    }, onError: (e) {
      print("Error during scan: $e");
    });



    // Wait for Bluetooth enabled & permission granted
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

    // Start scanning with a timeout
    await FlutterBluePlus.startScan(
      withServices: [Guid("180D")], // Match any of the specified services
      withNames: ["Bluno"], // Or match any of the specified names
      timeout: const Duration(seconds: 15),
    );

    // Wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }

  // Optionally, you can provide a callback function that will notify the UI about the updated devices
  void dispose() {
    _devicesStreamController.close(); // Close the StreamController to avoid memory leaks
  }
}

class ConnectBlue{

Future <void> Connect(var device) async{
// listen for disconnection
var subscription = device.connectionState.listen((BluetoothConnectionState state) async {
    if (state == BluetoothConnectionState.disconnected) {
        // 1. typically, start a periodic timer that tries to 
        //    reconnect, or just call connect() again right now
        // 2. you must always re-discover services after disconnection!
        print("${device.disconnectReason?.code} ${device.disconnectReason?.description}");
    }
});

// cleanup: cancel subscription when disconnected
//   - [delayed] This option is only meant for `connectionState` subscriptions.  
//     When `true`, we cancel after a small delay. This ensures the `connectionState` 
//     listener receives the `disconnected` event.
//   - [next] if true, the the stream will be canceled only on the *next* disconnection,
//     not the current disconnection. This is useful if you setup your subscriptions
//     before you connect.
device.cancelWhenDisconnected(subscription, delayed:true, next:true);

// Connect to the device
await device.connect();

// Disconnect from device
await device.disconnect();

// cancel to prevent duplicate listeners
subscription.cancel();


//AUTO CONNECT

// enable auto connect
//  - note: autoConnect is incompatible with mtu argument, so you must call requestMtu yourself
await device.connect(autoConnect:true, mtu:null);

// wait until connection
//  - when using autoConnect, connect() always returns immediately, so we must
//    explicity listen to `device.connectionState` to know when connection occurs 
await device.connectionState.where((val) => val == BluetoothConnectionState.connected).first;

// disable auto connect
await device.disconnect();





}



}