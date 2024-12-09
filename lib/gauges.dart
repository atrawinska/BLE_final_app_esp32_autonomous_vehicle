import 'package:blue_only_view/elements.dart';
import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'elements.dart';

int angle = 80;



class SpeedGauge extends StatelessWidget {
  double speedValue = 0;
   SpeedGauge(this.speedValue,{super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
        width: 270,
        height: 50,
        child: LinearGauge(
          linearGaugeBoxDecoration: const LinearGaugeBoxDecoration(
            thickness: 50,
            backgroundColor: Colors.white,
          ),
          pointers: [
            Pointer(
              value: speedValue,
              shape: PointerShape.rectangle,
              color: Color.fromARGB(150, 0, 0, 0),
              width: 10,
              height: 50,
            ),
          ],
          rulers: RulerStyle(
            showLabel: false,
            showSecondaryRulers: false,
            rulerPosition: RulerPosition.bottom,
            showPrimaryRulers: false,
          ),
          start: -1.6,
          end: 31.5,
          rangeLinearGauge: [
            RangeLinearGauge(
              borderRadius: 10,
              edgeStyle: LinearEdgeStyle.startCurve,
              start: -1.6,
              end: 10.0,
              color: customBlue,
            ),
            RangeLinearGauge(
              start: 10.0,
              end: 20.0,
              color: customYellow,
            ),
            RangeLinearGauge(
              edgeStyle: LinearEdgeStyle.endCurve,
              borderRadius: 10,
              start: 20.0,
              end: 31.5,
              color: customRed,
            ),
          ],
        ));
  }
}

class FullGaugeWidget extends StatelessWidget {
  double speedValue = 0;
  FullGaugeWidget(this.speedValue, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
     
       child: Column(
      children: [
        CustomText("Speed", size: 20, ownColor: customBlue,),
        const SizedBox(height: 5),
       

          SpeedGauge(speedValue),
         


          
        const SizedBox(height: 5),
        CustomText(speedValue.toString(), size: 20, ownColor: customBlue,),
        
      ],),
    );
  }
}

class ServoMeter extends StatelessWidget {
  const ServoMeter({super.key});

  @override
  Widget build(BuildContext context) {
        return Container(
      alignment: Alignment.center,
        width: 35,
       height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: const Color.fromARGB(255, 61, 120, 228),
        ),
        child: Transform.rotate(
          angle: 3.14159 * angle / 180,
          child:  Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ));
  }
}

class GuageRow extends StatelessWidget {
  double speedValue = 0;
  GuageRow(this.speedValue,{super.key});

  @override
  Widget build(BuildContext context) {
    return Container( 
      
      child: Row(
         mainAxisAlignment: MainAxisAlignment.center, 
         crossAxisAlignment: CrossAxisAlignment.center,// Center the widgets in the row
      children: [
        FullGaugeWidget(speedValue),
        const SizedBox(width: 10), // Add spacing between widgets
       // ServoMeter(), // Example angle, replace with your value
      ],
    ),
    );
  }
}
