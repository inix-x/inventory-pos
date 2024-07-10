import 'package:flutter/material.dart';

class Customsignout extends StatelessWidget {
  const Customsignout({super.key, this.onPressed, this.icon});
  final void Function()? onPressed;
  final Icon? icon; // Make icon optional

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40, // Increase height for better icon visibility
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
         backgroundColor: const Color.fromRGBO(31, 39, 37, 1), // Set background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Add rounded corners
          ),
        ),
        child: icon ?? const Text( // Display icon if provided, otherwise text
          'Sign Out',
          style: TextStyle(color: Colors.white, fontSize: 14), // White text
        ),
      ),
    );
  }
}
