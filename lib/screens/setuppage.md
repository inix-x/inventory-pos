import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';
import 'package:flutter_application_1/loginwidget/customersignout.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart'
    as category_provider;
import 'package:flutter_application_1/screens/additemspage.dart';
import 'package:flutter_application_1/screens/homepage.dart';
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
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _handleSignOut();
    }
  }

  void _addNewCategory() async {
    final categoryNameController = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Category'),
            content: TextField(
              autofocus: true,
              keyboardType: TextInputType.name,
              controller: categoryNameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    categoryName = categoryNameController.text;
                  });
                  if (categoryName.isNotEmpty) {
                    context
                        .read<category_provider.CategoryProvider>()
                        .addNewCat(
                            newCategoryNames: categoryName, newItems: []);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  void _removeCategory(int index) {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context, listen: false);
    categoryProvider.removeCategory(index);
    setState(() {});
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

  Future<void> _checkItemsAndSaveChanges() async {
    final DatabaseService dbService = DatabaseService.instance;
    final List<Map<String, Object?>> items = await dbService.fetchItems();

    if (items.isEmpty) {
      showDialog(
        // ignore: use_build_context_synchronously
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
    } else {
      Navigator.push(
        // ignore: use_build_context_synchronously
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
    final categoryName = categories.isNotEmpty ? categories.first.name : '';
    final List<Item> itemList = [];

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
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
              const Text(
                'Business Name',
                style: TextStyle(color: accentColor),
              ),
              const Spacer(),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: categories.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                categories.isNotEmpty
                    ? Flexible(
                        child: ListView.builder(
                          itemCount: context
                              .watch<category_provider.CategoryProvider>()
                              .categories
                              .length,
                          itemBuilder: (context, index) {
                            final category = context
                                .watch<category_provider.CategoryProvider>()
                                .categories[index];
                            return Dismissible(
                              key: Key(category.name),
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (_) => _removeCategory(index),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddItemspage(
                                        itemIndex: index,
                                        catName: categoryName,
                                        items:
                                            itemList, //di mna click to kase yung itemList is
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(category.name),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                              _removeCategory(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(child: Text('Add Categories here')),
            
                MaterialButton(
                  onPressed: _addNewCategory,
                  child: const Text('Add'),
                ),
                MaterialButton(
                  onPressed: () async {
                    await _checkItemsAndSaveChanges();
                  },
                  child: const Text('Save Changes'),
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
