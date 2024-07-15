// globals.dart
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/themeprovider.dart';

class GlobalDayNightSwitch extends StatefulWidget {
  const GlobalDayNightSwitch({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GlobalDayNightSwitchState createState() => _GlobalDayNightSwitchState();
}

class _GlobalDayNightSwitchState extends State<GlobalDayNightSwitch> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkSwitch = themeProvider.isDarkTheme;

    return DayNightSwitcherIcon(
      isDarkModeEnabled: isDarkSwitch,
      onStateChanged: (isDarkModeEnabled) {
        setState(() {
          themeProvider.toggleTheme();
        });
      },
    );
  }
}
