import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

 int printValue = 0;

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

  /// Navigate to the device details screen
  void _connectToDevice(BluetoothDevice device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailsScreen(device: device),
      ),
    );
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
                      trailing: const Icon(Icons.bluetooth_connected),
                      onTap: () => _connectToDevice(device),
                    );
                  },
                ),
    );
  }
}


//the other screen

class DeviceDetailsScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceDetailsScreen({required this.device, super.key});

  @override
  _DeviceDetailsScreenState createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  BluetoothCharacteristic? _rxCharacteristic;
  List<String> _receivedData = [];
  
  
  var lastData = '';
  bool _isConnecting = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToDevice();
  }

  /// Connect to the selected device
  Future<void> _connectToDevice() async {
    try {
      await widget.device.connect();
      setState(() => _isConnected = true);


      // Discover services and characteristics
      List<BluetoothService> services = await widget.device.discoverServices();
     

      // Look for a specific characteristic for receiving data (e.g., RX characteristic)
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          
            _rxCharacteristic = characteristic;

            // Set up a listener to receive data
            _rxCharacteristic!.lastValueStream.listen((value) {
              setState(() {

                if( value.length == 4){

                 printValue = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);

                                  }



                _receivedData.add((printValue).toString());
                
                
                
              });
            });

            await _rxCharacteristic!.setNotifyValue(true);
          
        }
      }
    } catch (e) {
      print("Error connecting to device: $e");
    } finally {
      setState(() => _isConnecting = false);
    }
  }

  @override
  void dispose() {
    if (_isConnected) {
      widget.device.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Device: ${widget.device.platformName}")),
      body: _isConnecting
          ? const Center(child: CircularProgressIndicator())
          : !_isConnected
              ? const Center(child: Text("Failed to connect to the device."))
              : Center( child: Column(
                
                  children: [
                    const Text("Received Data:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child:
                      Column(
                        

                        children: [
                          

                             Icon(
                            Icons.favorite_outline,
                            color: Color.fromARGB(255, 231, 61, 61),

                          ),

                          Text(
                            
                            
                            
                            printValue.toString())


                        ],




                      )

                     
                      
                      
                    ),
                  ],
                ),),
    );
  }
}
