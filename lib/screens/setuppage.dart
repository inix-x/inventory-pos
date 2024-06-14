
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/database/database_service.dart';
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
                final categoryName = categoryNameController.text;
                if (categoryName.isNotEmpty) {
                  context
                      .read<category_provider.CategoryProvider>()
                      .addNewCat(
                          newCategoryNames: categoryName, newItems: [], newStoreName: '');
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
          title: const Text('Add Category'),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.name,
            controller: storeNameController,
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
//   void _addNewStoreName() async {
//   final businessNameController = TextEditingController();

//     await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Add Business Name'),
//       content: TextField(
//         controller: businessNameController,
//         autofocus: true,
//         decoration: const InputDecoration(
//           labelText: 'Business Name',
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context), // Cancel button
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             if (businessNameController.text.isNotEmpty) {
//               setState(() {
//                 storeName = businessNameController.text;
//               });
//               Navigator.pop(context); // Save button
//             }
//           },
//           child: const Text('Save'),
//         ),
//       ],
//     ),
//   );
// }


  void _removeCategory(int index) {
    // Get the CategoryProvider instance using Provider.of
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context, listen: false);
    // Remove the category at the specified index from the provider
    categoryProvider.removeCategory(index);
    setState(() {});
    // No need to modify _categories (local list) or setState
  }

  void outputData() async {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context, listen: false);
    final categories = categoryProvider.categories;

    if (categories.isNotEmpty) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDocDir.path}/categories.json'; // Specific filename

      final file = File(filePath);

      // Encode categories list as JSON
      final jsonData =
          jsonEncode(categories.map((category) => category.toJson()).toList());

      // Write JSON data to file
      await file.writeAsString(jsonData);

      if (kDebugMode) {
        print('Successfully saved categories to $filePath');

        // Read the saved file content
        final fileContent = await file.readAsString();
        print('--- Saved File Content ---');
        print(fileContent);
      }

      
    } else {
      showToast(message: 'No categories found!');
      
    }
  }

  // void fetchData() async {

  //   //fetchData for Sqflite
  //   context.watch<category_provider.CategoryProvider>().fetchDatabase();
    
  // }

  // ignore: unused_element
  Future<String?> _readDataFromFile(String filePath) async {
    try { 
      final file = File(filePath);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      if (kDebugMode) {
        print('Error reading file: $e');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context);
    final categories = categoryProvider.categories;
    final businessName = categories.isNotEmpty ? categories.first.storeName : '';
    final categoryName = categories.isNotEmpty && categories.first.name.length > 1 ? categories.first.name[1] : '';
    final itemList = categories.isNotEmpty ? categories.first.items : [];

    
    // ignore: unused_field, no_leading_underscores_for_local_identifiers
    final DatabaseService _databaseService = DatabaseService.instance;
    // ignore: no_leading_underscores_for_local_identifiers
    final _auth = AuthService();
    // fetchData();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, //removing the automatic back to screen button
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Customsignout(
              onPressed: () async {
                await _auth.signout();
                // ignore: use_build_context_synchronously
                goToLogin(context);
              },
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white), // Add icon and color
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
                // onPressed: _addNewStoreName,
                icon: const Icon(
                  Icons.edit,
                  color: accentColor,
                )),
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
                  //change this make an empty final variable to hold the textfield value and make it the isEmtpy
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: context
                          .watch<category_provider.CategoryProvider>()
                          .categories
                          .length,
                      itemBuilder: (context, index) {
                        final category = context
                            .watch<category_provider.CategoryProvider>()
                            .categories[index];
                        return Dismissible(
                          key: Key(category.name), // Unique key for each card
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
                                    builder: (context) =>
                                        AddItemspage(itemIndex: index)),
                              );
                              //show another dialouge
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
                    )
                  : const Text('Add Categories here'),
              MaterialButton(
                onPressed: _addNewCategory,
                child: const Text('Add'),
              ),
              MaterialButton(
                onPressed: () {
                  if(categoryName == '') return;
                  outputData();
                  _databaseService.addToDatabase(businessName, categoryName, itemList as List<category_provider.Item>);
                  
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const HomeApp(isFinished: true)));
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
                  child: const Text('Get Local path'))
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

// void outputData() async {
//   final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
//   final categories = categoryProvider.categories;

//   if (categories.isNotEmpty) {
//     if (kDebugMode) {
//       print('--- Category List ---');
//     }
//     for (final category in categories) {
//       if (kDebugMode) {
//         print('Category Name: ${category.name}');

//       }
//       if (kDebugMode) {
//         print('Items:');
//       }
//       for (final item in category.items) {
//         if (kDebugMode) {
//           print('  - Name: ${item.name}');

//         }
//         if (kDebugMode) {
//           print('    Price: ${item.price}');

//         }
//         // Print other item properties as needed
//         if (kDebugMode) {
//         }
//       }
//       if (kDebugMode) {
//         print('---');
//       }
//     }
//   } else {
//     if (kDebugMode) {
//       print('No categories found.');
//     }
//   }
// }
