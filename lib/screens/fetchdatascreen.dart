import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/screens/homepage.dart';  // Ensure you have the correct path

class FetchDataScreen extends StatefulWidget {
  const FetchDataScreen({super.key});

  @override
  State<FetchDataScreen> createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeApp(isFinished: true)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flexible(
        child: Center(
            child: Container(
              height: 350,
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/fetchingdatapic.json', 
                      width: 350,
                      height: 300,
                    ),
                    const Text('Fetching Data...'),
                  ],
                ),
              ),
            ),
          
        ),
      ),
    );
  }
}
