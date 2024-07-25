// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/ordernumberprovider.dart';
// ignore: unused_import
import 'package:flutter_application_1/screens/getstarted.dart';
import 'package:flutter_application_1/screens/setupscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/themeprovider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart'
    as category_provider;

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => category_provider.CategoryProvider(categories: [])),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.themeData,
            debugShowCheckedModeBanner: false,
            home: const Setupscreen(),
            // home: const GetStarted(), //GetStarted to dapat
          );
        },
      ),
    );
  }
}
