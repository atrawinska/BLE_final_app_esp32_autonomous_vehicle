import 'package:flutter/material.dart';
import 'colorBox.dart';
import 'elements.dart';

class DefaultBox extends StatelessWidget {
  

  String? printValue;
  Color color = customBlue;

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
          color: customBlue,

          borderRadius: BorderRadius.circular(
              10.0), // Circular border radius for all corners
        ),
        child: Column(
          children: [
//put text and icon

            Icon(
              ownIcon,
              color: customWhite,
              
            ),
            SizedBox(width: 15), // This will add horizontal space (10px)

            CustomText(printValue.toString(), size: 15),
           
          ],
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget{
  //RowWidget(printValue1, printValue2, this.currColor, {super.key});

  Color currColor = customBlue;
   String printValue1 = "0";
   String printValue2 = "0";
   String printValue3 = "0";
  RowWidget(this.printValue1, this.printValue2, this.currColor, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: const EdgeInsets.all(10),
    child: Row( children: [


      DefaultBox(printValue1.toString(), currColor, Icons.abc_outlined),  
      DefaultBox(printValue2.toString(), currColor, Icons.abc_outlined),                    ///1st row with sensor data
      ColorBox(currColor),


    ],),

    
    );
  }

}