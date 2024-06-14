import 'package:flutter/foundation.dart';
// ignore: unnecessary_import
import 'package:flutter/material.dart';


//provider 
class CategoryProvider extends ChangeNotifier {
  //needs a conditional here to check if the sqflite table is not empty then make assign it to the categories List
  //else proceed with the original code below.
  //  final DatabaseService _databaseService = DatabaseService.instance; 
  List<Category> categories = [];

  CategoryProvider({
    required this.categories,
  });
    //para saan to?
    void updateCategories(List<Category> newCategories) {
    categories = newCategories;
    notifyListeners();
  }

  void addNewCat({
    // Renamed for clarity
    required List<Item> newItems, required String newCategoryNames, required String newStoreName,
  }) async {
    categories.add(Category(
      storeName: newStoreName,
      name: newCategoryNames,
      items: newItems, // Directly assign the provided newItems list
    ));
    notifyListeners();
  }

  void removeCategory(int index) {
  categories.removeAt(index);
  notifyListeners(); // Notify listeners in your Setuppage class about the change
}

  void removeItem(int index) {  
  categories[index].items.removeAt(index);
  notifyListeners(); // Notify listeners in your Setuppage class about the change
}
  // void fetchDatabase()  async {
  //   //get the database by fetching 
  //   List <Category> categories1 =  await _databaseService.fetchData() ;
  //   if (kDebugMode) {
  //     print(categories1.toList());
  //   }
  //   notifyListeners();
  // }

}

//data model
class Category {
  final String storeName;
  final String name;
  final List<Item> items;

  
  Category({ required this.name,  required this.items, required this.storeName, });
  Map<String, dynamic> toJson() => {
    'storeName' :  storeName,
    'name': name,
    'items': items.map((item) => item.toJson()).toList(), // Recursively convert items
  };
}

class Item {
  final String name;
  final double price;
  final String imagePath;
  int count; // Added for tracking item count
  final int max; // Added for setting maximum allowed

  Item({
    required this.name,
    required this.price,
    required this.imagePath,
    this.count = 0, // Set default count to 0
    required this.max,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'imagePath': imagePath,
    'count': count,
    'max': max,
  };

 
}

