import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PairedDevicesScreen(),
    );
  }
}

class PairedDevicesScreen extends StatefulWidget {
  @override
  _PairedDevicesScreenState createState() => _PairedDevicesScreenState();
}

class _PairedDevicesScreenState extends State<PairedDevicesScreen> {
  List<BluetoothDevice> _pairedDevices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPairedDevices();
  }

  /// Fetch paired devices and update the UI
  Future<void> _fetchPairedDevices() async {
    try {
      // Ensure Bluetooth is supported
      if (await FlutterBluePlus.isSupported == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bluetooth is not supported on this device.")),
        );
        return;
      }

      // Wait for Bluetooth to be turned on
      await FlutterBluePlus.adapterState
          .where((state) => state == BluetoothAdapterState.on)
          .first;

      // Retrieve bonded (paired) devices
      List<BluetoothDevice> bondedDevices = await FlutterBluePlus.bondedDevices;

      setState(() {
        _pairedDevices = bondedDevices;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching paired devices: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paired Bluetooth Devices")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pairedDevices.isEmpty
              ? const Center(child: Text("No paired devices found."))
              : ListView.builder(
                  itemCount: _pairedDevices.length,
                  itemBuilder: (context, index) {
                    BluetoothDevice device = _pairedDevices[index];
                    return ListTile(
                      title: Text(device.platformName.isNotEmpty
                          ? device.platformName
                          : "Unknown Device"),
                      subtitle: Text("ID: ${device.remoteId}"),
                      onTap: () async {
                        // Handle device selection (e.g., connect to the device)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Selected: ${device.platformName}")),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
