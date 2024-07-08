import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    const String firstWord = 'Easy';
    const String secondWord = 'Professional';

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/animations/page1.jpg'),
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
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  children: const [
                    TextSpan(text: 'Make your Business '),
                    TextSpan(
                      text: firstWord,
                      style: TextStyle(
                       
                        color: Colors.blueAccent, // Color for the first word
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' & '),
                    TextSpan(
                      text: secondWord,
                      style: TextStyle(
                        color: Colors.green, // Color for the second word
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ],
                )),
              ),
            ),
            Container(
              alignment: const Alignment(0, 0.75),
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('The best POS Application that you can use to help all your business needs!',
                style: GoogleFonts.robotoSerif(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
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
