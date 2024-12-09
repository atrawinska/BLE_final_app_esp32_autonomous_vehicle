import 'package:flutter/material.dart';
import 'elements.dart';


import 'boxes.dart';

class ColorBox extends StatelessWidget {



  Color color = customBlue;

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
              color: isDarkColor() ? customWhite : customBlack,
              size: 35,
            ),
      ),
    );
  }


 bool isDarkColor() {
    // Extract the ARGB values from the color object
    int argb = color.value;  // color.value contains the 32-bit ARGB value

    // Extract the RGB components from the ARGB value
    int red = (argb >> 16) & 0xFF;
    int green = (argb >> 8) & 0xFF;
    int blue = argb & 0xFF;

    // Calculate the luminance
    double luminance = 0.2126 * red / 255 +
                       0.7152 * green / 255 +
                       0.0722 * blue / 255;

    // Return true if the luminance is less than 0.5 (dark color), otherwise false (light color)
    return luminance < 0.5;
  }
}