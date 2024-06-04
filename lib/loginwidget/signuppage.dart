import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/custombutton.dart';
import 'package:flutter_application_1/loginwidget/customtextfield.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:flutter_application_1/screens/setuppage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService(); // Use your custom AuthService

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isVisible = false;
  
  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }
   void isPasswordVisible(){
    setState(() {
      isVisible = !isVisible;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text("Signup",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 50,
            ),
            CustomTextField(
              hint: "Enter Name",
              label: "Name",
              controller: _name, obscure: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email, obscure: false,
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: isVisible,
              controller: _password,
              decoration: InputDecoration(
                hintText: "Enter your Password",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                label: const Text('Password'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey, width: 1)),
                suffixIcon: IconButton(onPressed: isPasswordVisible, icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Signup",
              onPressed: _signup,
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Already have an account? "),
              InkWell(
                onTap: () => goToLogin(context),
                child: const Text("Login", style: TextStyle(color: Colors.red)),
              )
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeApp(isFinished: true,)),
      );
  
  goToSetup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Setuppage()),
      );

 _signup() async {
  final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
  if (user != null) {
    log("User Created Succesfully");
    if (mounted) { // Check if widget is still mounted
      goToSetup(context);
    }
  }
}

}
