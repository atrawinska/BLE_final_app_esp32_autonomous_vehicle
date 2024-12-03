import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';


///Battery box indicator with a battery icon
class BatteryWidget extends StatelessWidget {
  BatteryWidget(printValue, {super.key});

  double printValue = 0;

  @override
  Widget build(BuildContext context) {
    return //BATTERY
        Expanded(
       
            child: 
            Padding(
              padding: const EdgeInsets.all(10),


              child: 
              
              
            
            LinearPercentIndicator(
      animation: true,
      progressColor: const Color.fromARGB(255, 120, 65, 169),
      barRadius: const Radius.circular(10),

      ///change to battery value
      percent: printValue / 10 > 1 ? printValue / 100 : printValue / 10,
      animationDuration: 500,
      animateFromLastPercent: true,
      lineHeight: 50,
      width: 150,

      center: const Icon(
        Icons.battery_charging_full_sharp,
        color: Color.fromARGB(255, 255, 255, 255),
        size: 30,
      ),
    ))
              
              
              
              
              ,
            
            
            
            );
            }
}


///Text to display the battery percentage
class BatteryText extends StatelessWidget {
  BatteryText(printValue, {super.key});

  int printValue = 0;

  @override
  Widget build(BuildContext context) {
        return Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          
          (printValue / 10).toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
          selectionColor: const Color.fromARGB(255, 3, 3, 3),
        ));

  }
}

class RowBattery extends StatelessWidget{
RowBattery(printValue, {super.key});

int? printValue;

@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(

      children: [


        BatteryText(printValue),
        BatteryWidget(printValue),






      ],



    );
  }



}