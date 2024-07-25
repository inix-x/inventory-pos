import 'package:flutter/material.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:flutter_application_1/screens/menupage.dart';
import 'package:flutter_application_1/screens/outofstockpage.dart';
import 'package:flutter_application_1/themes/settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/themeprovider.dart';
import 'package:flutter_application_1/themes/theme_color.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key, required bool isFinished});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

bool _isFinished = false;

class _HomeAppState extends State<HomeApp> with WidgetsBindingObserver {
  late ThemeProvider themeProvider;
  int _selectedTileIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  void _onTileTap(int index) {
    setState(() {
      _selectedTileIndex = index;
    });
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
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu,
                      color: isDarkTheme
                          ? ThemeColors.darkSignoutIconColor
                          : ThemeColors.lightSignoutIconColor),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              const Spacer(),
              Text('Menu', style: Theme.of(context).textTheme.displayMedium),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: isDarkTheme
                      ? ThemeColors.darkIconColor
                      : ThemeColors.lightIconColor,
                ),
                onPressed: () {
                  SettingsDialog.show(context);
                },
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                ListTile(
                  title: Text('Business Name',
                      style: Theme.of(context).textTheme.displaySmall),
                  subtitle: Text('bizness@gmail.com',
                      style: Theme.of(context).textTheme.displaySmall),
                  tileColor: Colors.transparent,
                  trailing: IconButton(
                    icon: Icon(Icons.close,
                        color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  leading: Icon(Icons.inventory,
                      color: Theme.of(context).iconTheme.color),
                  title: Text('Inventory',
                      style: _selectedTileIndex == 0
                          ? Theme.of(context).textTheme.labelSmall
                          : Theme.of(context).textTheme.displaySmall),
                  tileColor: _selectedTileIndex == 0
                      ? Theme.of(context).focusColor
                      : Colors.transparent,
                  onTap: () {
                    _onTileTap(0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OutOfStockPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  leading: Icon(Icons.money,
                      color: Theme.of(context).iconTheme.color),
                  title: Text('Sales',
                      style: _selectedTileIndex == 1
                          ? Theme.of(context).textTheme.labelSmall
                          : Theme.of(context).textTheme.displaySmall),
                  tileColor: _selectedTileIndex == 1
                      ? Theme.of(context).focusColor
                      : Colors.transparent,
                  onTap: () {
                    _onTileTap(1);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const OutOfStockPage(),
                    //   ),
                    // );
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  leading: Icon(Icons.phone,
                      color: Theme.of(context).iconTheme.color),
                  title: Text('Support',
                      style: _selectedTileIndex == 2
                          ? Theme.of(context).textTheme.labelSmall
                          : Theme.of(context).textTheme.displaySmall),
                  tileColor: _selectedTileIndex == 2
                      ? Theme.of(context).focusColor
                      : Colors.transparent,
                  onTap: () {
                    _onTileTap(2);
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  leading: Icon(Icons.person_add,
                      color: Theme.of(context).iconTheme.color),
                  title: Text('Refer-A-Friend',
                      style: _selectedTileIndex == 3
                          ? Theme.of(context).textTheme.labelSmall
                          : Theme.of(context).textTheme.displaySmall),
                  tileColor: _selectedTileIndex == 3
                      ? Theme.of(context).focusColor
                      : Colors.transparent,
                  onTap: () {
                    _onTileTap(3);
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  leading: Icon(Icons.settings,
                      color: Theme.of(context).iconTheme.color),
                  title: Text('Settings',
                      style: _selectedTileIndex == 4
                          ? Theme.of(context).textTheme.labelSmall
                          : Theme.of(context).textTheme.displaySmall),
                  tileColor: _selectedTileIndex == 4
                      ? Theme.of(context).focusColor
                      : Colors.transparent,
                  onTap: () {
                    _onTileTap(4);
                    SettingsDialog.show(context);
                  },
                ),
                // Add more drawer items here
              ],
            ),
          ),
        ),
        body: MenuScreen(
          isFinished: _isFinished,
        ),
      ),
    );
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

  Future<void> _handleSignOut() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final _auth = AuthService();
    await _auth.signout();
    if (mounted) {
      goToLogin(context);
    }
  }

  bool shouldPop(Route<dynamic> route) {
    return false; // Always return false to prevent back navigation
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
}
