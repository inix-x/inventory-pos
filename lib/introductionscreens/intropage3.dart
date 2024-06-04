import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const IntroPage3());
}

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

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
                'Your business in your pocket.',
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
                    'Manage sales, inventory, and customers - all on the go.',
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
            color: Colors.transparent,
            child: Center(
              child: Lottie.asset(
                  'assets/animations/checkouthand.json'),
            ),
          ),
        ],
      ),
    );
  }
}
