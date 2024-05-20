import 'package:flutter/material.dart';
import '../screens/menupage.dart';
import '../screens/accountpage.dart';

void main() {
  runApp(const HomeApp());
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const MenuScreen(),
      const AccountScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: const Text('Omar\'s Eatery ',
              style: TextStyle(color: Colors.black)),
        ),
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: Colors.white12,
            selectedIndex: index,
            onDestinationSelected: (int newIndex) =>
                setState(() => index = newIndex),
            destinations: const [
              NavigationDestination(
                icon: Padding(
                  padding:
                      EdgeInsets.all(3.0), // Adjust padding values as needed
                  child: Icon(Icons.home),
                ),
                label: 'Menu',
              ),
              NavigationDestination(
                icon: Padding(
                  padding:
                      EdgeInsets.all(3.0), // Adjust padding values as needed
                  child: Icon(Icons.person_2_rounded),
                ),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
