import 'package:flutter/material.dart';
import 'colorBox.dart';

class DefaultBox extends StatelessWidget {
  

  String? printValue;
  Color color = const Color.fromARGB(255, 120, 65, 169);

  IconData ownIcon = Icons.favorite_border;

  DefaultBox(this.printValue, this.color, this.ownIcon, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Container( 
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 120, 65, 169),

          borderRadius: BorderRadius.circular(
              10.0), // Circular border radius for all corners
        ),
        child: Column(
          children: [
//put text and icon

            Icon(
              ownIcon,
            ),
            Text(
              printValue.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget{
  //RowWidget(printValue1, printValue2, this.currColor, {super.key});

  Color currColor = const Color.fromARGB(255, 120, 65, 169);
   String printValue1 = "0";
   String printValue2 = "0";
   String printValue3 = "0";
  RowWidget(this.printValue1, this.printValue2, this.currColor, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: const EdgeInsets.all(10),
    child: Row( children: [


      DefaultBox(printValue1.toString(), const Color.fromARGB(255, 120, 65, 169), Icons.abc_outlined),  
      DefaultBox(printValue2.toString(), const Color.fromARGB(255, 120, 65, 169), Icons.abc_outlined),                    ///1st row with sensor data
      ColorBox(currColor),


    ],),

    
    );
  }

}