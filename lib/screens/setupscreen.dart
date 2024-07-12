// ignore_for_file: use_build_context_synchronously

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/customersignout.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart'
    as category_provider;
import 'package:flutter_application_1/providers/themeprovider.dart';
import 'package:flutter_application_1/screens/additemspage.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/themes/theme_color.dart';

class Setupscreen extends StatefulWidget {
  const Setupscreen({super.key});

  @override
  State<Setupscreen> createState() => _SetupscreenState();
}

class _SetupscreenState extends State<Setupscreen> with WidgetsBindingObserver {
  bool _isSwitched = ThemeProvider().isDarkTheme;

  late ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _handleSignOut();
    }
  }

  Future<void> _handleSignOut() async {
    final authService = AuthService();
    await authService.signout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final categoryNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Category',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.name,
            controller: categoryNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category Name',
              hintText: 'Enter a category',
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 247, 247, 247),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green),
              ),
              onPressed: () => _addCategory(categoryNameController.text.trim()),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCategory(String categoryName) async {
    final validCategoryName = RegExp(r'^[a-zA-Z\s]+$');
    if (categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Category name cannot be empty',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (!validCategoryName.hasMatch(categoryName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category name can only contain letters and spaces'),
        ),
      );
      return;
    }

    final dbService = DatabaseService.instance;
    final existingCategory =
        await dbService.fetchCategoryByNameChecker(categoryName);

    if (existingCategory.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The category name already exists')),
      );
      return;
    }

    context.read<category_provider.CategoryProvider>().addNewCat(
      newCategoryNames: categoryName,
      newItems: [],
    );
    Navigator.pop(context);
  }

  void _removeCategory(int index) {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context, listen: false);
    categoryProvider.removeCategory(index);
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

  Future<void> _checkItemsAndSaveChanges() async {
    final dbService = DatabaseService.instance;
    final List<Map<String, Object?>> items = await dbService.fetchItems();

    if (items.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("No Items Found"),
            content: const Text("There are no items in the database."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeApp(isFinished: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context);
    final categories = categoryProvider.categories;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var isDarkTheme = themeProvider.isDarkTheme;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _showLogoutConfirmation,
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
              Text(
                'Business Name',
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
        body: Container(
          decoration: BoxDecoration(
            gradient: isDarkTheme
                ? const LinearGradient(
                    colors: [
                      ThemeColors.darkGradientStart,
                      ThemeColors.darkGradientEnd,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : const LinearGradient(
                    colors: [
                      ThemeColors.lightGradientStart,
                      ThemeColors.lightGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: categories.isNotEmpty
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                categories.isNotEmpty
                    ? Flexible(
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoryCard(
                              category: category,
                              onDelete: () => _removeCategory(index),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddItemspage(
                                      itemIndex: index,
                                      items: const [],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDarkTheme
                                ? ThemeColors.darkEmptyMessageContainerColor
                                : ThemeColors.lightEmptyMessageContainerColor),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Add Categories here',
                            style: GoogleFonts.robotoSerif(
                              textStyle: TextStyle(
                                color: isDarkTheme
                                    ? ThemeColors.darkEmptyMessageColor
                                    : ThemeColors.lightEmptyMessageColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                ActionButton(
                  text: 'Add',
                  onPressed: _showAddCategoryDialog,
                  isDarkTheme: isDarkTheme,
                ),
                ActionButton(
                  text: 'Save Changes',
                  onPressed: _checkItemsAndSaveChanges,
                  isDarkTheme: isDarkTheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final category_provider.Category category;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkTheme = themeProvider.isDarkTheme;

    return Dismissible(
      key: Key(category.name),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: isDarkTheme
                ? ThemeColors.darkCardColor
                : ThemeColors.lightCardColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon:  Icon(
                      Icons.delete,
                      color: isDarkTheme ? ThemeColors.darkDeleteIconColor : ThemeColors.lightDeleteIconColor,
                    ),
                    onPressed: onDelete,
                  ),
                  Text(
                    category.name,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        letterSpacing: 2,
                        color: isDarkTheme
                            ? ThemeColors.darkTextColor
                            : ThemeColors.lightTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon:  Icon(
                      Icons.arrow_right_alt,
                      color: isDarkTheme ? ThemeColors.darkDeleteIconColor : ThemeColors.lightDeleteIconColor,
                    ),
                    onPressed: onTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDarkTheme;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: MaterialButton(
          color: isDarkTheme
              ? ThemeColors.darkButtonColor
              : ThemeColors.lightButtonColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: isDarkTheme
                    ? ThemeColors.darkButtonTextColor
                    : ThemeColors.lightButtonTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

goToLogin(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
