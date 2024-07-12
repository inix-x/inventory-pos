import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/themeprovider.dart';
import 'package:flutter_application_1/themes/theme_color.dart';
import 'package:provider/provider.dart';

class Customsignout extends StatelessWidget {
  const Customsignout({super.key, this.onPressed, this.icon});
  final void Function()? onPressed;
  final Icon? icon; // Make icon optional
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return SizedBox(
      width: 40,
      height: 40, // Increase height for better icon visibility
      child: ElevatedButton(
        onPressed: onPressed,
        
        style: ElevatedButton.styleFrom(
         backgroundColor: themeProvider.isDarkTheme ?  ThemeColors.lightSignoutIconColor :  ThemeColors.darkSignoutIconColor, // Set background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Add rounded corners
          ),
          elevation: 0,
        ),
        child: icon ?? const Text( // Display icon if provided, otherwise text
          'Sign Out',
          style: TextStyle(color: Colors.white, fontSize: 14), // White text
        ),
      ),
    );
  }
}
