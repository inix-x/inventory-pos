import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    const String firstWord = 'Effortless ';
    const String secondWord = 'Inventory ';
    const String thirdWord = 'Management.';

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/animations/page2.jpg'),
            fit: BoxFit.cover,
          )),
          child: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black12, Colors.black87])),
            ),
            Container(
              alignment: const Alignment(0, 0.55),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                    text:  TextSpan(
                  style:  GoogleFonts.robotoSerif(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  children: const [
                    
                    TextSpan(
                      text: firstWord,
                      style: TextStyle(
                       
                        color: Colors.blueAccent, // Color for the first word
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  
                    TextSpan(
                      text: secondWord,
                      style: TextStyle(
                        color: Colors.white, // Color for the second word
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: thirdWord,
                      style: TextStyle(
                        color: Colors.blue, // Color for the second word
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
              ),
            ),
            Container(
              alignment: const Alignment(0, 0.75),
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: 
                Text('Never run out of stock again. Stay organized with our app.',
                style: GoogleFonts.robotoSerif(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                )
              
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
