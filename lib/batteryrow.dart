import 'package:blue_only_view/elements.dart';
import 'package:flutter/material.dart';

import 'package:percent_indicator/percent_indicator.dart';

///Battery box indicator with a battery icon
class BatteryWidget extends StatelessWidget {
  BatteryWidget(this.value, {super.key});

  int value = 0;

  @override
  Widget build(BuildContext context) {
    return //BATTERY
        Padding(
          
          padding: const EdgeInsets.all(10),
          child:  
          Row( 
            mainAxisAlignment: MainAxisAlignment.center,
      
            
            children: [
          
          LinearPercentIndicator(
              animation: true,
              progressColor: customGreen,
              barRadius: const Radius.circular(10),

              ///change to battery value
              percent: 0.8, //value.toDouble(),
              animationDuration: 500,
              animateFromLastPercent: true,
              lineHeight: 65,
              width: 160,
              center: RowBattery(value),
              
              
              ),]),
    );
  }
}

///Text to display the battery percentage
class BatteryText extends StatelessWidget {
  String printValue = "80";
  BatteryText(this.printValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: CustomText(
          "$printValue%", size: 15, ownFontWeight: FontWeight.bold,)
        );
  }
}

class RowBattery extends StatelessWidget {
  int printValue;
  RowBattery(this.printValue, {super.key});


  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [BatteryText(printValue.toString()),
                   Transform.rotate(angle: 3.14159*90/180,
                  child: 
                  Icon(
                    Icons.battery_charging_full,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 30,
                  ),
                  
                  
                  
                  ),
                  
                  
      ],
    );
  }
}

double calculateBatteryPercent(int value) {
  double percentage = 80.0;

  return percentage;
}

