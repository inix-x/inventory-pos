// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' ;
import 'package:flutter/material.dart'; 
import 'package:flutter_application_1/providers/categoryprovider.dart' as category_provider ;
import 'package:flutter_application_1/screens/additemspage.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Setuppage extends StatefulWidget {
  const Setuppage({super.key}); 

  @override
  State<Setuppage> createState() => _SetuppageState();
}
String storeName = '';
class _SetuppageState extends State<Setuppage> {
  // ignore: prefer_final_fields

  void _addNewCategory() async {
    final categoryName = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Category Name',
              ),
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
          ),
        ],
      ),
    );
    if (categoryName != null && categoryName.isNotEmpty) {
      setState(() {
        context.read<category_provider.CategoryProvider>().addNewCat(
            newCategoryNames: categoryName, newItems: [], newStoreName: storeName);
      });
    }
  }

  void _addNewStoreName() async {
    final businessName = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Add Business Name'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Business Name',
              ),
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
          ),
        ],
      ),
    );
    if (businessName != null && businessName.isNotEmpty) {
      setState(() {
        storeName = businessName;
      });
    }
  }

  void _removeCategory(int index) {
    // Get the CategoryProvider instance using Provider.of
    final categoryProvider =
        Provider.of<category_provider.CategoryProvider>(context, listen: false);
    // Remove the category at the specified index from the provider
    categoryProvider.removeCategory(index);
    setState(() {
      
    });
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
      if (kDebugMode) {
        print('No categories found to save.');
      }
    }
  }
void fetchData() async {
  const appDocPath = '/data/user/0/com.example.flutter_application_1/app_flutter/categories.json';
  final data = await _readDataFromFile(appDocPath);
  if (data != null) {
    final decodedData = jsonDecode(data) as List<dynamic>;
     final categories = decodedData.map((categoryData) => Category(categoryData as List<String>)).toList();
    // ignore: use_build_context_synchronously
    context.read<category_provider.CategoryProvider>().updateCategories(categories.cast<category_provider.Category>()); // Update provider with alias
  }
}


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
   
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [ 
          //try to make a new class for the store name instead in the categoryprovider.dart
          storeName.isEmpty ? 
          const Text('Business Name') :  Text('$storeName'), 
          IconButton(onPressed: _addNewStoreName, icon: const Icon(Icons.edit)),
        ],
      )),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              context.watch<category_provider.CategoryProvider>().categories.isNotEmpty
               //change this make an empty final variable to hold the textfield value and make it the isEmtpy 
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          context.watch<category_provider.CategoryProvider>().categories.length,
                      itemBuilder: (context, index) {
                        final category =
                            context.watch<category_provider.CategoryProvider>().categories[index];
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
                  outputData();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeApp(isFinished: true)));
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
                child: const Text('Get Local path')

              )
            ],
          ),
        ),
      ),
    );
  }
}


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
