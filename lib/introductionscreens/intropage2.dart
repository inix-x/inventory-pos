import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const IntroPage2());
}

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20),
            child: Container(
              alignment: const Alignment(0, 0),
              color: Colors.transparent,
              child: const Text(
                'Effortless inventory management.',
                style: TextStyle(
                  fontSize: 45,
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
                    'Never run out of stock again. Stay organized with our app.',
                    style: TextStyle(
                      fontSize: 20,
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
                  'assets/animations/inventoryanimation.json',
                  width: 350,
                  height: 350,),
                  
            ),
          ),
        ],
      ),
    );
  }
}
