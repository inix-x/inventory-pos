// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/global/common/toast.dart';
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

class _SetuppageState extends State<Setuppage> {
  String storeName = '';
  String categoryName = '';

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

  // Future<List<Map<String, Object?>>> fetchData() async {
  //   final db = await DatabaseService.instance.database;
  //   final maps = await db.query('menu');
  //   return maps.toList();
  // }

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

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context);
    final categories = categoryProvider.categories;

    final categoryName = categories.isNotEmpty ? categories.first.name : '';
    final List<Item> itemList = [];

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                context
                        .watch<category_provider.CategoryProvider>()
                        .categories
                        .isNotEmpty
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
                    : 
                const Text('Add Categories here'),
                const Spacer(),
                MaterialButton(
                  onPressed: _addNewCategory,
                  child: const Text('Add'),
                ),
                MaterialButton(
                  onPressed: () {
                    if (categoryName == '') {
                      showToast(message: 'No categories found!');
                      return;
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeApp(isFinished: true),
                        ),
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
                const Spacer(),
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
