import 'package:flutter/material.dart';
import 'elements.dart';

class  CustomNavigationBar extends StatelessWidget{
  String text = '';
   CustomNavigationBar(this.text, {super.key});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 100,
      color: Colors.transparent,
      child: QuestionElevatedButton(text),
      

    );
  }
}