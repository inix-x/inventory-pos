import 'package:flutter/material.dart';
// import './screens/homepage.dart'; // Assuming your homepage is in a screens folder
import './introductionscreens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: Hide debug banner in all modes
      home: OnboardingScreen(),
    );
  }
}
