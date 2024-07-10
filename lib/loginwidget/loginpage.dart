import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/global/common/toast.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/signuppage.dart';
import 'package:flutter_application_1/screens/fetchdatascreen.dart';
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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void isPasswordVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Future<List<Map<String, Object?>>> fetchData() async {
    final db = await DatabaseService.instance.database;
    final maps = await db.query('categories');
    return maps.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false, //this line of code disable the screen's resizing when typing something
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(58, 67, 80, 1),
        ),
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
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "We missed you!",
                style: GoogleFonts.robotoSerif(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // const Spacer(),
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  label: const Text('Email'),
                  labelStyle: const TextStyle(
                      color: Colors.white), // Set label color to white
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2)),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    label: const Text('Password'),
                    labelStyle: const TextStyle(
                        color: Colors.white), // Set label color to white
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1)),
                    suffixIcon: IconButton(
                        onPressed: isPasswordVisible,
                        icon: isVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        color: Colors.white),
                    prefixIcon: const Icon(Icons.key, color: Colors.white)),
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
                          'Sign In',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.white),
                ),
                InkWell(
                  onTap: () => goToSignup(context),
                  child: const Text("Signup",
                      style: TextStyle(color: Colors.blue)
                      ),
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

  goToFetchData(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FetchDataScreen()),
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

      try {
        final user = await _auth.loginUserWithEmailAndPassword(
            _email.text, _password.text);

        if (user != null) {
          if (kDebugMode) {
            showToast(message: 'Successfully Logged In!');
          }
          if (mounted) {
            final checkDb = await fetchData();
            if (checkDb.isEmpty) {
              // ignore: use_build_context_synchronously
              goToSetup(context);
            } else {
              // ignore: use_build_context_synchronously
              goToFetchData(context);
            }
          }
        }
      } catch (e) {
        showToast(message: 'Login failed. Please try again.');
      } finally {
        if (mounted) {
          setState(() {
            isSigningIn = false;
          });
        }
      }
    }
  }
}
