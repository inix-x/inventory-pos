import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


void main() {
  runApp(const IntroPage1());
}


class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
    
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              alignment: const Alignment(0, 0),
              color: Colors.transparent,
              child: const Text(
                'Make your Business Easy & Professional.',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
            child: Container(
              alignment: const Alignment(0, 0),
              color: Colors.transparent,
              child: const Wrap(
                children: [
                  Text(
                    'The best POS Application that you can use to help all your business needs!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 350,
            color: Colors.transparent,
            child: Center(
              child: Lottie.asset(
                  'assets/animations/checkoutcart.json', 
                  width: 350,
                  height: 350,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
