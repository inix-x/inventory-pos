import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/global/common/toast.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/signuppage.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:flutter_application_1/screens/setuppage.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSigningIn = false;
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isVisible = true;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  void isPasswordVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center elements horizontally
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              const Flexible(
                flex: 3,
                child: SizedBox(
                  height: 300,
                  child: AspectRatio(
                    // color: Colors.red,
                    aspectRatio: 3 / 2,
                    child: Image(
                      image: AssetImage('assets/animations/loginscreenpic.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Welcome back!",
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "We missed you!",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // const Spacer(),
              TextField(
                obscureText: false,
                controller: _email,
                decoration: InputDecoration(
                    hintText: "Enter your email",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    label: const Text('Email'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1)),
                    prefixIcon: const Icon(Icons.email)),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: isVisible,
                controller: _password,
                decoration: InputDecoration(
                    hintText: "Enter your Password",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    label: const Text('Password'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1)),
                    suffixIcon: IconButton(
                        onPressed: isPasswordVisible,
                        icon: isVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                    prefixIcon: const Icon(Icons.key)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 180,
                height: 42,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Set button color
                  ),
                  child: isSigningIn
                      ? const CircularProgressIndicator(
                          color: accentColor,
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? "),
                InkWell(
                  onTap: () => goToSignup(context),
                  child:
                      const Text("Signup", style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 5),
              ]),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeApp(
                  isFinished: true,
                )),
      );

  goToSetup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Setuppage()),
      );

  _login() async {
    if (_email.text == '') {
      showToast(message: 'Please enter your email');
    } else if (_password.text == '') {
      showToast(message: 'Please enter your password.');
    } else {
      setState(() {
        isSigningIn = true;
      });
      final user = await _auth.loginUserWithEmailAndPassword(
          _email.text, _password.text);

      setState(() {
        isSigningIn = false;
      });
      if (user != null) {
        if (kDebugMode) {
          print("User Logged In");
        }
        // ignore: use_build_context_synchronously
        goToSetup(context);
      }
    }
  }
}
