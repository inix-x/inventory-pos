import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}
bool _isClicked = false;

class _AccountScreenState extends State<AccountScreen> {

  void backToMenu(BuildContext context){
   Navigator.pop(context);
   setState(() {
  _isClicked = false;
    });
}
 // Change to StatelessWidget for simplicity
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    
    return Scaffold( // Use Scaffold for app bar and navigation
      appBar: AppBar(
        title: const Text('Account'),
        
      ),
      body: const Center(child: Text('Account', style: TextStyle(fontSize: 72))),
      bottomNavigationBar: Container(
                height: 70,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                       
                          color: !_isClicked ?  Colors.black : accentColor,
                          child: MaterialButton(
                            onPressed: ()=> backToMenu(context),
                            child:  Icon(
                            Icons.menu_book,
                           
                            color: _isClicked ?  primaryColor : accentColor,
                            size: 20,
                            
                          ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 15,
                      // ),
                      const DottedLine(
                        direction: Axis.vertical,
                        alignment: WrapAlignment.center,
                        dashLength: 5,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashColor: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                            color: !_isClicked ? accentColor : primaryColor,
                            child:  MaterialButton(
                              onPressed: (){
                              setState(() {
                                _isClicked = true;
                              });
                            }, // Pass context explicitly
                              child:  Icon(
                                Icons.account_circle,
                                color: _isClicked ? accentColor : primaryColor,
                                size: 25,
                              )
                            )
                            ),
                      )
                    ],
                  ),
                ),
              ),
    );
  }
}
