import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert'; 



///widgets
import "widgets.dart";
import 'boxes.dart';
import 'batteryrow.dart';

int dataType = 0;
int printValue = 0;
int Red = 0;
int Green = 0;
int Blue = 0;
int DistanceCm1 = 0;
int DistanceCm2 = 0;
int isObject = 1;


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
  const PairedDevicesScreen({super.key});

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
          const SnackBar(
              content: Text("Bluetooth is not supported on this device.")),
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
  final List<String> _receivedData = [];

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
              if (value.length == 7) {
                dataType = value[0];
                DistanceCm1 = value[1];
                DistanceCm2 = value[2];
                Red = value[3];
                Green = value[4];
                Blue = value [5];
                isObject = value[6];
                 print("Received Data: $dataType $DistanceCm1, $DistanceCm2, $Red, $Green, $Blue, $isObject");
                
              }
              List<int> data = [DistanceCm1, DistanceCm2, Red, Green, Blue, isObject];
              data.forEach((value)=> _receivedData.add(value.toString()));

              //_receivedData.a(DistanceCm1, DistanceCm2, Red, Green, Blue, isObject);
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

Future<void> sendData(List<int> data) async{

//List<int> data = [0x00];
  if(_rxCharacteristic != null){

    try{

     await _rxCharacteristic!.write(data);
      print("Value sent");




    }
    catch (e){
      print("Error $e");
    }

  }


}

  


  @override
  Widget build(BuildContext context) {
   bool isSwitched = false;
    return Scaffold(
      appBar: AppBar(title: Text("Device: ${widget.device.platformName}")),
      body: _isConnecting
          ? const Center(child: CircularProgressIndicator())
          : !_isConnected
              ? const Center(child: Text("Failed to connect to the device."))
              : Center(
                  child: Column(
                    children: [          

                      RowWidget(DistanceCm1.toString(), DistanceCm2.toString(), Color.fromARGB(255, Red, Green, Blue)),  
                      RowBattery(DistanceCm1),          
                      
                      GaugeWidget(DistanceCm1.toDouble()),
                      Text(
                         "Received Data: $DistanceCm1, $DistanceCm2, $Red, $Green, $Blue, $isObject",
                      ),

                      Padding(padding: EdgeInsets.all(10) ,
                      child: 

                      Switch(
                        value: isSwitched,
                       onChanged: (value)async{
                        setState(() {
                          isSwitched = value;
                          
                        });
                        List<int> data;
                        if(isSwitched==true){
                          data = [0x01];
                        }
                        else data = [0x02];
                        await sendData(data);

                       }
                       

                       
                       )
                      ,
                      
                      
                      )
                      
                      //here put other code to the column
                    ],
                  ),
                ),
    );
  }
}
