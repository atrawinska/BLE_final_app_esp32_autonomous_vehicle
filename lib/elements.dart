import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///File with theme elements like texts, colours
///
///
///
///
///text widget
///defined colour
///box withj question - what this will be?
///

Color customBlue = Color.fromARGB(255, 67, 117, 226);
Color customYellow = Color.fromARGB(255, 255, 255, 77);
Color customRed = Color.fromARGB(255, 255, 107, 109);
Color customGreen = Color.fromARGB(255, 50, 196, 27);
Color customBlack = Color.fromARGB(255, 0, 0, 0);
Color customWhite = Color.fromARGB(255, 255, 255, 255);
Color customGrey = Color.fromARGB(255, 218, 218, 218);



class CustomText extends StatelessWidget{

  String words = '';
  double size = 10.0;
  Color ownColor ;
  FontWeight ownFontWeight;
CustomText(this.words, {this.size = 10.0,this.ownColor = Colors.white, this.ownFontWeight = FontWeight.w600, super.key});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Text(
    "$words",
    style: GoogleFonts.nunito(
        color: ownColor,
        fontSize: size, // Adjust the font size as needed
        fontWeight: ownFontWeight, // Optional: Adjust weight (normal, bold, etc.)
      ),

   );
  }
}


class QuestionElevatedButton extends StatelessWidget{

  QuestionElevatedButton({super.key});

  @override
  Widget build(BuildContext context){

    return Align( 
      alignment: Alignment.bottomRight,
      
      
      
      child: Container(
      margin: EdgeInsets.all(16),
    
      child: 
       ElevatedButton(
    
     child: Icon(Icons.question_mark, color: customWhite),

      style: ButtonStyle(
        
        backgroundColor: WidgetStatePropertyAll(customBlue),
        padding: WidgetStatePropertyAll(EdgeInsets.all(16)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
          ),
        ),
      ),



    

    onPressed: (){},


    ),





    )
    );
  }

  


}