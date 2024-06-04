// getstarted.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/introductionscreens/onboarding_screen.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:provider/provider.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryProvider>(
      create: (context) => CategoryProvider(categories: []),
      child: Scaffold(
        body: _auth.isLoggedIn() ? const HomeApp(isFinished: true) : const OnboardingScreen(),
      ),
    );
  }
}
