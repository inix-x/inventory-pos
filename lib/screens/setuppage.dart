import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
import 'package:path_provider/path_provider.dart';
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
                            newCategoryNames: categoryName,
                            newItems: [],
                            newStoreName: storeName);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  void _addNewStoreName() async {
    final storeNameController = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Store Name'),
            content: TextField(
              autofocus: true,
              keyboardType: TextInputType.name,
              controller: storeNameController,
              decoration: const InputDecoration(
                labelText: 'Store Name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final storeNameHolder = storeNameController.text;
                  if (storeNameHolder.isNotEmpty) {
                    setState(() {
                      storeName = storeNameHolder;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  Future<List<Map<String, Object?>>> fetchData() async {
    final db = await DatabaseService.instance.database;
    final maps = await db.query('menu');
    return maps.toList();
  }

  void _removeCategory(int index) {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context, listen: false);
    categoryProvider.removeCategory(index);
    setState(() {});
  }

  void outputData() async {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context, listen: false);
    final categories = categoryProvider.categories;

    if (categories.isNotEmpty) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDocDir.path}/categories.json';

      final file = File(filePath);
      final jsonData =
          jsonEncode(categories.map((category) => category.toJson()).toList());
      await file.writeAsString(jsonData);

      if (kDebugMode) {
        print('Successfully saved categories to $filePath');
        final fileContent = await file.readAsString();
        print('--- Saved File Content ---');
        print(fileContent);
        print('-------------------------');
      }
      if (mounted) {
        context.read<category_provider.CategoryProvider>().fetchDatabase();
      }
    } else {
      showToast(message: 'No categories found!');
    }
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

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context);
    final categories = categoryProvider.categories;
    final businessName =
        categories.isNotEmpty ? categories.first.storeName : '';
    final categoryName = categories.isNotEmpty ? categories.first.name : '';
    final itemList = categories.isNotEmpty ? categories.first.items : [];
// ignore: no_leading_underscores_for_local_identifiers
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Customsignout(
              onPressed: _handleSignOut,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            const Spacer(),
            storeName.isEmpty
                ? const Text(
                    'Business Name',
                    style: TextStyle(color: accentColor),
                  )
                : Text(
                    storeName,
                    style: const TextStyle(color: accentColor),
                  ),
            IconButton(
              onPressed: _addNewStoreName,
              icon: const Icon(
                Icons.edit,
                color: accentColor,
              ),
            ),
            const Spacer(),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
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
                                      storeName: businessName,
                                      items: itemList
                                          as List<category_provider.Item>,
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
                                        onPressed: () => _removeCategory(index),
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
                  : const Text('Add Categories here'),
              MaterialButton(
                onPressed: _addNewCategory,
                child: const Text('Add'),
              ),
              MaterialButton(
                onPressed: () {
                  if (categoryName == '') return;
                  outputData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeApp(isFinished: true),
                    ),
                  );
                },
                child: const Text('Save Category and Items'),
              ),
              MaterialButton(
                onPressed: () async {
                  final appDocDir = await getApplicationDocumentsDirectory();
                  final appDocPath = appDocDir.path;
                  if (kDebugMode) {
                    print('This is the app directory: $appDocPath');
                  }
                },
                child: const Text('Get Local path'),
              ),
            ],
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
