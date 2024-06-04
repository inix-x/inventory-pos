import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart';
import 'package:flutter_application_1/screens/getstarted.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_application_1/screens/homepage.dart';
// import 'package:flutter_application_1/loginwidget/loginpage.dart';
// import './screens/homepage.dart'; // Assuming your homepage is in a screens folder
// import './introductionscreens/onboarding_screen.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp()
  );
}

// void main () {
//   runApp(const MyApp()
//   );
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => CategoryProvider(categories: []),
      ),
    ],
    child:  const MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: Hide debug banner in all modes
      home: GetStarted(),
    ), 
    );
  }
}