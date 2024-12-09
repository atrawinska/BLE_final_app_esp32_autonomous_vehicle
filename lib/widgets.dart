import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Widget for speed measurements
class GaugeWidget extends StatelessWidget {
  GaugeWidget(printValue, {super.key});
  double printValue = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ///gauge
        SfRadialGauge(
          enableLoadingAnimation: true,
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          title: const GaugeTitle(text: "Current speed"),
          axes: <RadialAxis>[
            RadialAxis(
              startAngle: 90, //180, //90
              endAngle: 450, //360, //445 almost a circle
              axisLineStyle: AxisLineStyle(
                  cornerStyle: CornerStyle.bothCurve,
                  thickness: 30,
                  gradient: SweepGradient(
                    colors: [
                      Colors.greenAccent.shade400,
                      const Color.fromARGB(255, 255, 216, 21),
                      Colors.redAccent.shade400,
                    ],
                    stops: const [
                      0.0,
                      0.5,
                      1.0
                    ], //when the gradient should change colour
                  )),
              minimum: 0,
              maximum: 100,
              pointers: <GaugePointer>[NeedlePointer(value: printValue)],
            )
          ],
        ),
      ]),
    );
  }
}
//linear gauge



class CustomGauge extends StatelessWidget{
 CustomGauge({super.key});

 @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: EdgeInsets.all(10),
    child: 


      SfLinearGauge(

         
 minimum: 0.0,
  maximum: 100.0,
  interval: 20 ,
 ranges: [],
barPointers: [],
  markerPointers: [],
orientation: LinearGaugeOrientation.horizontal,
  isAxisInversed: false,

  animateAxis: false,
animateRange: false,

animationDuration: 1000,
showLabels : true,
showAxisTrack : true,
showTicks : true,
minorTicksPerInterval : 1,
useRangeColorForAxis: false,
axisTrackExtent: 0,
labelPosition: LinearLabelPosition.inside,




      ),








    


    );
  }





}

