import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/custombutton.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:flutter_application_1/screens/setuppage.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool isVisible = true;
  
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center, // Center elements horizontally
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            const SizedBox(
              // color: Colors.red,
              height: 220,
              width: 250,
              child: Image(
                image: AssetImage('assets/animations/signupscreenpic.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              "Join us today! ",
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            TextField(
              obscureText: false,
              controller: _name,
              decoration: InputDecoration(
                  hintText: "Enter your name",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  label: const Text('Name'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1)),
                  prefixIcon: const Icon(Icons.person)),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: false,
              controller: _email,
              decoration: InputDecoration(
                  hintText: "Enter your email",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  label: const Text('Email'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1)),
                  prefixIcon: const Icon(Icons.email)),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: isVisible,
              controller: _password,
              decoration: InputDecoration(
                hintText: "Enter your Password",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                label: const Text('Password'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey, width: 1)),
                prefixIcon: const Icon(Icons.key),
                suffixIcon: IconButton(onPressed: isPasswordVisible, icon: isVisible ? const Icon(Icons.visibility_off) :  const Icon(Icons.visibility)),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              label: "Signup",
              onPressed: _signup,
            ),
            
             const SizedBox(height: 10),
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
