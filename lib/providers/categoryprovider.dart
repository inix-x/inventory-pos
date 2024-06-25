import 'dart:convert';

import 'package:flutter/foundation.dart';
// ignore: unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database.service.dart';

//provider
class CategoryProvider extends ChangeNotifier {
  //needs a conditional here to check if the sqflite table is not empty then make assign it to the categories List
  //else proceed with the original code below.
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Category> categories = [];

  CategoryProvider({
    required this.categories,
  });

  void addNewCat({
    // Renamed for clarity
    required List<Item> newItems,
    required String newCategoryNames,

  }) async {
    categories.add(Category(
      name: newCategoryNames,
      items: newItems, // Directly assign the provided newItems list
    ));
    _databaseService.addCategory(newCategoryNames);
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

  void fetchDatabase() async {
    //get the database by fetching
    List categories1 = await _databaseService.fetchCategories();
    if (kDebugMode) {
      print(categories1.toList());
    }
    notifyListeners();
  }
}

//data model
class Category {
  final String name;
  final List<Item> items;

  Category({
    required this.name,
    required this.items,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'items': items
            .map((item) => item.toJson())
            .toList(), // Recursively convert items
      };
}

class Item {
  final String name;
  final double price;
  final String imagePath;
  final int count;
  final int max;

  Item({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.count,
    required this.max,
  });

  Map<String, dynamic> toMap(int categoryId) {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'count': count,
      'max': max,
      'categoryId': categoryId,
    };
  }

  static String encode(List<Item> items, int categoryId) => json.encode(
        items
            .map<Map<String, dynamic>>((item) => item.toMap(categoryId))
            .toList(),
      );

  static List<Item> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<Item>((item) => Item.fromMap(item))
          .toList();

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'],
      price: map['price'],
      imagePath: map['imagePath'],
      count: map['count'],
      max: map['max'],
    );
  }
  
  toJson() {}
}
