import 'package:flutter/material.dart';

void main() {
  runApp(const AccountScreen());
}
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Expanded(
        child: Center(child: Text('Account', style: TextStyle(fontSize: 72))),
      ),
    );
  }
}
