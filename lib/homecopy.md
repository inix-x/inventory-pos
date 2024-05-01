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
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('Omar\'s Eatery ', style: TextStyle(color: Colors.black)),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  // Update the state of the app

                  // Then close the drawer
                },
              ),
              ListTile(
                title: const Text('Business'),
                onTap: () {
                  // Update the state of the app

                  // Then close the drawer
                },
              ),
              const ListTile(
                title: Text('School'),
              ),
            ],
          ),
        ),
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: const Color(0xFFf1f5fb),
            selectedIndex: index,
            onDestinationSelected: (int newIndex) =>
                setState(() => index = newIndex),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Menu'),
              NavigationDestination(
                  icon: Icon(Icons.person_2_rounded), label: 'Account'),
            ],
          ),
        ),
      ),
    );
  }
}
