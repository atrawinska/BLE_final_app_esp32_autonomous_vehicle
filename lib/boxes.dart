import 'package:flutter/material.dart';

class DefaultBox extends StatelessWidget {
  DefaultBox(printValue, color, ownIcon, {super.key});

  String? printValue;
  Color color = Color.fromARGB(255, 120, 65, 169);

  IconData ownIcon = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Container( 
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 120, 65, 169),

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
  RowWidget(printValue1, printValue2, printValue3,{super.key});

   String? printValue1;
   String? printValue2;
   String? printValue3;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: EdgeInsets.all(10),
    child: Row( children: [


      DefaultBox(printValue1.toString(), Color.fromARGB(255, 120, 65, 169), Icons.abc_outlined),  
      DefaultBox(printValue2.toString(), Color.fromARGB(255, 120, 65, 169), Icons.abc_outlined),                    ///1st row with sensor data
      DefaultBox(printValue3.toString(), Color.fromARGB(255, 120, 65, 169), Icons.favorite_outline),


    ],),

    
    );
  }

}