import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert'; 
import 'elements.dart';
import 'switch_widget.dart';
import 'gauges.dart';
import 'navigation_bar.dart';
import 'battery_calculate.dart';
//import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';





///widgets
import "widgets.dart";
import 'boxes.dart';
import 'batteryrow.dart';

//data to receive
int dataType = 0;
int Red = 0;
int Green = 0;
int Blue = 0;
int DistanceCm1 = 0;
int DistanceCm2 = 0;
int speedValue = 0;
int batteryFactor = 0; //it will be initially multiplied by 10
int servoDegrees = 90;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
      ),
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
       
      appBar: AppBar(title: CustomText("Paired Bluetooth Devices", size: 23, ownColor: customBlack,), backgroundColor: customWhite,  centerTitle: true, ),
      body: Container( child: 
      
      
      
      _isLoading
          ? Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            CircularProgressIndicator(color: customBlue,),
              SizedBox(height: 20),            
             CustomText("Remember to pair with a desired device through your phone's settings.", size: 15, ownColor: customBlue, ownFontWeight: FontWeight.bold,),


          ],)) 
          : _pairedDevices.isEmpty
              ? const Center(child: Text("No paired devices found."))
              : ListView.builder(
                  itemCount: _pairedDevices.length,
                  itemBuilder: (context, index) {
                    BluetoothDevice device = _pairedDevices[index];
                     return Card(
                    elevation: 4, // Adds shadow for box effect
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8), // Margin between cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    child: ListTile(
                      tileColor: customBlue,
                      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners
  ),
                      title: CustomText(
                        (device.platformName.isNotEmpty? device.platformName : "Unknown Device"), size: 15,
                            ownColor: Color.fromARGB(255, 255, 255, 255),
                          
                      ),
                     
                      trailing: const Icon(Icons.bluetooth_connected, color: Color.fromARGB(255, 255, 255, 255) ),
                      onTap: () => _connectToDevice(device),
                    ),
                  );      

                  },
                ),),
                bottomNavigationBar:  CustomNavigationBar("1. First ensure if you have paired with the autonomous vehicle in your device's settings.\n2.Now, it should be visible in the list of paired devices.\n3.Click the autonomous vehicle.\n4.Control and see its readings! "),
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
                speedValue = value[6]; //IR
                //batteryFactor = value[7];
               // motorSpeed = value[8];
                ///servoDegrees = value[9];
                 print("Received Data: $dataType $DistanceCm1, $DistanceCm2, $Red, $Green, $Blue, $speedValue");
                
              }
              List<int> data = [DistanceCm1, DistanceCm2, Red, Green, Blue, speedValue];
              data.forEach((value)=> _receivedData.add(value.toString()));

              //_receivedData.a(DistanceCm1, DistanceCm2, Red, Green, Blue, isObject);
            });
          });

          await _rxCharacteristic!.setNotifyValue(true);
        }
      }
    } catch (e) {
      print("Error connecting to device: $e, try again");
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

  

   bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText("Device: ${widget.device.platformName}", size: 23, ownColor: customBlack,), centerTitle: false,),
      body: _isConnecting
          ?  Center(child: CircularProgressIndicator( color: customBlue))
          : !_isConnected
              ? Center(child: CustomText("Failed to connect to the device. Try again",))
              : Center(
                  child: 
                  
                  SingleChildScrollView( child: 
                  Column( 
                    mainAxisSize: MainAxisSize.min,
                    children: [       

                      CustomSwitch(onSendData: sendData), 
                      SizedBox(height: 50),
                      BatteryWidget(CalculateBatteryPercentage(batteryFactor)),   
                      SizedBox(height: 30),
                      RowWidget(DistanceCm1.toString(), DistanceCm2.toString(), Color.fromARGB(255, Red, Green, Blue)),  
                            SizedBox(height: 20),
                      FullGaugeWidget(speedValue.toDouble()),
                      // GaugeWidget(DistanceCm1.toDouble()),
                      // Text(
                      //    "Received Data: $DistanceCm1, $DistanceCm2, $Red, $Green, $Blue, $isObject",
                      // ),

                
                    

                      
                      //here put other code to the column
                     // const Spacer(),
                     // QuestionElevatedButton(),
                    ],
                   
                  ),
                  ),
                ),
                bottomNavigationBar: CustomNavigationBar("First, you can turn on and off the main motor,\nthen you can see its battery's percentage,\nbelow how far away it is from detected objects and a color it detects,\nand then also its speed."),
    );
  }
}


//.altenative code for switch - works:
      // Padding(padding: EdgeInsets.all(10) ,
                      // child: 

                      

                      // Switch(
                      //   value: isSwitched,
                      //  onChanged: (value) async{
                        
                        
                      //   List<int> data = [0x00];
                      //   if(isSwitched==true){
                          
                      //     data = [0x01];
                      //   }
                      //   else if(isSwitched==false) {data = [0x02]; }
                        
                      //   try{
                      //    await sendData(data);
                         
                      //    setState(() {
                      //     isSwitched = value;
                      //     print("New value: $isSwitched");
                          
                      //   });
                      //   print("New value after state: $isSwitched");
                      //   }
                      //   catch(e){
                      //     print("An error $e has occured");
                      //     setState(() {
                      //       isSwitched = !value; // Revert if there's an error
                      //     });
                      //   }
                        

                      //  }
                       

                       
                      //  )
                      // ,
                      
                      
                      // ),

