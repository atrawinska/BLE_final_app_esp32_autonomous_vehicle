import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'elements.dart';

class CustomSwitch extends StatefulWidget {
  final Function(List<int>) onSendData;
  const CustomSwitch({super.key, required this.onSendData});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool isStartSelected = false;
  List<int> data = [0x00];
  bool isRunning = false;
  Color mainThemeColor = customBlue;
  Color secondMainColor = const Color.fromARGB(255, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return Container( 
    
      

      
      decoration: BoxDecoration(
        color:  mainThemeColor,    


        borderRadius: BorderRadius.circular(15),
      ),
      
      
      
      
      child:   Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: 
                
                () async {
                  data = [0x01]; //means that soimething wrong 
                
               
                  try { //await ?
                     widget.onSendData(data); //send value

                    setState(() {
                      
                      isRunning = !isRunning;

                      isStartSelected = !isStartSelected;
                    });
                    print("True - data sent");
                  } catch (e) {
                    print(e);
                    print("False because it didn't work");
                  }
                  
                },
                child: AnimatedContainer(
                    curve: Curves.linear,
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 50),
                    decoration: BoxDecoration(
                      color: isStartSelected ? secondMainColor : mainThemeColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: mainThemeColor,
                      ),
                    ),
                    child: Text(
                      "Start",
                      style: GoogleFonts.nunito(
                        color: isStartSelected ? Colors.black : Colors.white,
                        fontSize: 18, // Adjust the font size as needed
                        fontWeight: FontWeight
                            .w600, // Optional: Adjust weight (normal, bold, etc.)
                      ),
                    )),
              ),
              GestureDetector(
                onTap: 
                () async{


                  data = [0x02];

                  try{
                    await widget.onSendData(data);

                    
                    setState(() {
                      
                      isRunning = !isRunning;

                      isStartSelected = !isStartSelected;
                    });
                    print("True - data sent");

                  }
                  catch (e){

              
                    print("False because it didn't work + $e");

                  }
                
                  print("FALSE");
                },
                child: AnimatedContainer(
                  curve: Curves.linear,
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  decoration: BoxDecoration(
                    color: !isStartSelected ? secondMainColor : mainThemeColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: mainThemeColor,
                    ),
                  ),
                  child: Text(
                    "Stop",
                    style: GoogleFonts.nunito(
                      color: isStartSelected
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18, // Adjust the font size as needed
                      fontWeight: FontWeight
                          .w600, // Optional: Adjust weight (normal, bold, etc.)
                    ),
                  ),
                ),
              ),
            ],),
          );
      
  }
}
