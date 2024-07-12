// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/customersignout.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart'
    as category_provider;
import 'package:flutter_application_1/screens/additemspage.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Setuppage extends StatefulWidget {
  const Setuppage({super.key});

  @override
  State<Setuppage> createState() => _SetuppageState();
}

class _SetuppageState extends State<Setuppage> with WidgetsBindingObserver {
  String storeName = '';
  String categoryName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  void _addNewCategory() async {
    final categoryNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Category',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )),
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
                      const Color.fromARGB(255, 247, 247, 247))),
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.green)),
              onPressed: () async {
                setState(() {
                  categoryName = categoryNameController.text.trim();
                });

                // Regular expression to check for alphabets and spaces only
                final validCategoryName = RegExp(r'^[a-zA-Z\s]+$');

                if (categoryName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.black,
                      content: Text('Category name cannot be empty',
                          style: TextStyle(color: Colors.white)),
                    ),
                  );
                } else if (!validCategoryName.hasMatch(categoryName)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Category name can only contain letters and spaces'),
                    ),
                  );
                } else {
                  final dbService = DatabaseService.instance;
                  final existingCategory =
                      await dbService.fetchCategoryByNameChecker(categoryName);
                  if (existingCategory.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The category name already exists'),
                      ),
                    );
                  } else {
                    context
                        .read<category_provider.CategoryProvider>()
                        .addNewCat(
                      newCategoryNames: categoryName,
                      newItems: [],
                    );
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _removeCategory(int index) {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context, listen: false);
    categoryProvider.removeCategory(index);
    setState(() {});
  }

  // Sign out
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

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(31, 39, 37, 1),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Customsignout(
                onPressed: _onWillPop,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              const Spacer(),
              Text(
                'Business Name',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromRGBO(43, 42, 51, 1),
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
                            return Dismissible(
                              key: Key(category.name),
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (_) => _removeCategory(index),
                              child: GestureDetector(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: const Color.fromRGBO(66, 65, 77, 1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            category.name,
                                            style: GoogleFonts.robotoSerif(
                                              textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.white),
                                            onPressed: () =>
                                                _removeCategory(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          'Add Categories here',
                          style: GoogleFonts.robotoSerif(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(
                            66, 65, 77, 1), // Set the background color
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: _addNewCategory,
                      child: Text(
                        'Add',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(
                            66, 65, 77, 1), // Set the background color
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        await _checkItemsAndSaveChanges();
                      },
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
