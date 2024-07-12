// ignore: unused_import
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/customersignout.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../screens/menupage.dart';
import '../screens/accountpage.dart';
import 'package:flutter_application_1/providers/themeprovider.dart';
import 'package:flutter_application_1/themes/theme_color.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key, required bool isFinished});
  // static final GlobalKey<NavigatorState> navigatorKey =
  //     GlobalKey<NavigatorState>();
  @override
  State<HomeApp> createState() => _HomeAppState();
}

// ignore: unused_element
bool _isClicked = false;
bool _isFinished = false;

class _HomeAppState extends State<HomeApp> {
  bool _isSwitched = ThemeProvider().isDarkTheme;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  void navigateToAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountScreen()),
    );
    setState(() {
      _isClicked = false;
    });
  }

  //signout
  Future<void> _handleSignOut() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final _auth = AuthService();
    await _auth.signout();
    if (mounted) {
      goToLogin(context);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Do you really want to log out?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  _handleSignOut();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> _showLogoutConfirmation() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Do you really want to log out?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  _handleSignOut();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var isDarkTheme = themeProvider.isDarkTheme;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDarkTheme
              ? ThemeColors.darkAppBarBackground
              : ThemeColors.lightAppBarBackground,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Customsignout(
                onPressed: _showLogoutConfirmation,
                icon: Icon(Icons.arrow_back_ios,
                    color: isDarkTheme
                        ? ThemeColors.darkSignoutIconColor
                        : ThemeColors.lightSignoutIconColor),
              ),
              const Spacer(),
              // Text(businessName.isEmpty ? 'Nothing\'s here ' : 'Yep', style: const TextStyle(color: accentColor)),
               Text(
                'Menu',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2,
                    color: isDarkTheme
                        ? ThemeColors.darkIconColor
                        : ThemeColors.lightIconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
               DayNightSwitcherIcon(
                isDarkModeEnabled: _isSwitched,
                onStateChanged: (isDarkModeEnabled) {
                  setState(() {
                    _isSwitched = isDarkModeEnabled;
                    
                  });
                  themeProvider.toggleTheme();
                },
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        body: MenuScreen(
          isFinished: _isFinished,
        ),
      ),
    );
  }

  bool shouldPop(Route<dynamic> route) {
    return false; // Always return false to prevent back navigation
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
}
