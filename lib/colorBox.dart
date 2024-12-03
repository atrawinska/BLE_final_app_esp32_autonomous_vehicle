import 'package:flutter/material.dart';

import 'boxes.dart';

class ColorBox extends StatelessWidget {
  

  Color color = const Color.fromARGB(255, 120, 65, 169);

  IconData ownIcon = Icons.favorite_border;

ColorBox(this.color, {super.key});

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
          color: color,

          borderRadius: BorderRadius.circular(
              10.0), // Circular border radius for all corners
        ),
        child: Icon(
              Icons.palette_outlined, //change color to ??
              
            ),
      ),
    );
  }
}