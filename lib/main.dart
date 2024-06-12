import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart';
import 'package:flutter_application_1/screens/getstarted.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: "../.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['GOOGLE_API_KEY']!,
      appId: dotenv.env['APP_ID']!,
      messagingSenderId: dotenv.env['PROJECT_ID']!,
      projectId: dotenv.env['PROJECT_ID']!,
    ),
  );
  runApp(const MyApp());
}


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