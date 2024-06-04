import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];

  CategoryProvider({
    required this.categories,
  });

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



}

class Category {
  final String name;
  final List<Item> items;
  final String storeName;

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

