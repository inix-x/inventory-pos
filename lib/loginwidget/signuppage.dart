import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/global/common/toast.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:flutter_application_1/screens/setupscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService(); // Use your custom AuthService

  // final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isVisible = true;
  bool isSigningIn = false; 

  @override
  void dispose() {
    // _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void isPasswordVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Future<void> _handleSignup() async {
    if (_email.text == '') {
      showToast(message: 'Please enter your email');
      return;
    } else if (_password.text == '') {
      showToast(message: 'Please enter your password.');
      return;
    }

    setState(() {
      isSigningIn = true;
    });

    try {
      final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);

      if (user != null) {
        showToast(message: 'User Created Successfully');
        if (mounted) {
          goToSetup(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    } catch (e) {
      showToast(message: 'An unexpected error occurred.');
    } finally {
      if (mounted) {
        setState(() {
          isSigningIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(58, 67, 80, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Center elements horizontally
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              const Flexible(
                flex: 3,
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: FittedBox(
                      child: Image(
                        image: AssetImage('assets/animations/signupscreenpic1.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Join us today!",
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                "Manage your business with style!",
                style: GoogleFonts.robotoSerif(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: const TextStyle(color: Colors.white),
                obscureText: false,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9@._-]'),
                  ),
                ],
                decoration: InputDecoration(
                  hintText: "Enter your email",
                   hintStyle: const TextStyle(
                      color: Colors.white), // Set hint text color to white
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  label: const Text('Email'),
                   labelStyle: const TextStyle(
                      color: Colors.white), // Set 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                style: const TextStyle(color: Colors.white),
                obscureText: isVisible,
                controller: _password,
                decoration: InputDecoration(
                  hintText: "Enter your Password",
                   hintStyle: const TextStyle(
                      color: Colors.white), // Set hint text color to white
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  label: const Text('Password'),
                   labelStyle: const TextStyle(
                      color: Colors.white), // Set 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  prefixIcon: const Icon(Icons.key, color: Colors.white),
                  suffixIcon: IconButton(
                    onPressed: isPasswordVisible,
                    icon: isVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),  color: Colors.white
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 180,
                height: 42,
                child: ElevatedButton(
                  onPressed: _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Set button color
                  ),
                  child: isSigningIn 
                      ? const CircularProgressIndicator(color: accentColor)
                      : const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ", style: TextStyle(color: Colors.white),),
                  InkWell(
                    onTap: () => goToLogin(context),
                    child: const Text("Login", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
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
    MaterialPageRoute(builder: (context) => const HomeApp(isFinished: true)),
  );

  goToSetup(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Setupscreen()),
  );
}
