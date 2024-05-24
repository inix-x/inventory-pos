import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import '../screens/menupage.dart';
import '../screens/accountpage.dart';


class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

bool _isClicked = false;
bool _isFinished = true;

class _HomeAppState extends State<HomeApp> {

   void navigateToAccount(BuildContext context) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => const AccountScreen()),
    );
    setState(() {
      _isClicked = false  ;
    });
  }
  

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: const Text('Omar\'s Eatery ',
                style: TextStyle(color: accentColor)
                ),
         
        ),
        body:  MenuScreen(isFinished: _isFinished,),
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
                          color: !_isClicked ? accentColor : primaryColor,
                          child: MaterialButton(
                            onPressed: (){
                              setState(() {
                                _isClicked = !_isClicked;
                              });
                            },
                            child:  Icon(
                            Icons.menu_book,
                            color: _isClicked ? accentColor : primaryColor,
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
                            color: _isClicked ? accentColor : primaryColor,
                            child:  MaterialButton(
                              onPressed: () => navigateToAccount(context), // Pass context explicitly
                              child:  Icon(
                                Icons.account_circle,
                                color: !_isClicked ? accentColor : primaryColor,
                                size: 25,
                              )
                            )
                            ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
