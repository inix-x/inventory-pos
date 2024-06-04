import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/custombutton.dart';
import 'package:flutter_application_1/loginwidget/customtextfield.dart';
import 'package:flutter_application_1/loginwidget/signuppage.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:flutter_application_1/screens/setuppage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isVisible = false;

  @override
  void dispose() {
    super.dispose();
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
            const Text("Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email,
              obscure: false,
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
              label: "Login",
              onPressed: _login,
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Already have an account? "),
              InkWell(
                onTap: () => goToSignup(context),
                child:
                    const Text("Signup", style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () => const HomeApp(
                  isFinished: true,
                ),
                child: const Text('Use Offline'),
              )
            ]),
            const Spacer()
          ],
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
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      if (kDebugMode) {
        print("User Logged In");
      }
      // ignore: use_build_context_synchronously
      goToSetup(context);
    }
  }
}
