// themeprovider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/themes/theme_color.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeData get themeData {
    return _isDarkTheme ? darkTheme : lightTheme;
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    if (kDebugMode) {
      print(_isDarkTheme);
    }
    notifyListeners();
  }

  bool get isSwitchDark {
    return _isDarkTheme;
  }

  ThemeData get darkTheme {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.darkAppBarBackground,
      ),
       drawerTheme: const DrawerThemeData(
        backgroundColor: ThemeColors.darkGradientStart
      ),
      iconTheme: const IconThemeData(
        color: ThemeColors.darkIconColor,
      ),
      cardColor: ThemeColors.darkCardColor,
    
      textTheme: TextTheme(
        displayMedium: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 25,
            letterSpacing: 2,
            color: ThemeColors.darkIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        displaySmall: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            letterSpacing: 2,
            color: ThemeColors.darkIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        titleSmall: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            color: ThemeColors.lightIconColor,
            fontWeight: FontWeight.bold,
          ),
        ), // Define other text styles as needed

        //horizontal category scrollview
        labelSmall: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            color: ThemeColors.darkIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      focusColor: ThemeColors.tilefocusColorDark,
      primaryColor: ThemeColors.darkAlertDialogColor,
      highlightColor: ThemeColors.checkoutButtonColor,
      scaffoldBackgroundColor: ThemeColors.scaffoldBgColorDark,
    );
  }

  ThemeData get lightTheme {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.lightAppBarBackground,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: ThemeColors.scaffoldBgColorLight
      ),
      iconTheme: const IconThemeData(
        color: ThemeColors.lightIconColor,
      ),
      cardColor: ThemeColors.lightCardColor,
      textTheme: TextTheme(
        displayMedium: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 25,
            letterSpacing: 2,
            color: ThemeColors.lightIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        displaySmall: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            letterSpacing: 2,
            color: ThemeColors.lightIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        titleSmall: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            color: ThemeColors.darkIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        labelSmall: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            color: ThemeColors.darkIconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      focusColor: ThemeColors.tilefocusColorLight,
      primaryColor: ThemeColors.lightAlertDialogColor,
      highlightColor: ThemeColors.checkoutButtonColor,
      scaffoldBackgroundColor: ThemeColors.scaffoldBgColorLight,
    );
  }
}
