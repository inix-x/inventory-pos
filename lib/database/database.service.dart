import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
}

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'master_db.db');
    final database = await openDatabase(databasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          categoryName TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          price REAL NOT NULL,
          imagePath TEXT,
          count INTEGER NOT NULL,
          categoryId INTEGER NOT NULL,
          FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
        )
      ''');
    });
    return database;
  }

  Future<void> addCategoryWithItems(
      String categoryName, List<Item> items) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Insert the category
        int categoryId = await txn.insert('categories', {
          'categoryName': categoryName,
        });
        if (categoryId == 0) {
          throw ('Error adding category with items to database');
        }
        if (items.isNotEmpty && !(categoryId.isNaN)) {
          for (var item in items) {
            await txn.insert('items', item.toMap(categoryId));
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding category with items to database: $e');
      }
    }
  }

  Future<void> addItems(int categoryId, List<Item> items) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Insert the items
        if (items.isNotEmpty && !(categoryId.isNaN)) {
          for (var item in items) {
            await txn.insert('items', item.toMap(categoryId));
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding category with items to database: $e');
      }
    }
  }

  Future<Map<String, Object?>?> addCategory(String categoryName) async {
    final db = await database;
    try {
      int categoryId = -1;
      await db.transaction((txn) async {
        categoryId = await txn.insert('categories', {
          'categoryName': categoryName,
        });
      });

      if (categoryId != -1) {
        final List<Map<String, Object?>> maps = await db.query(
          'categories',
          where: 'id = ?',
          whereArgs: [categoryId],
        );
        if (maps.isNotEmpty) {
          return maps.first;
        }
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding category with items to database: $e');
      }
      return null;
    }
    return null;
  }

  Future<List<Map<String, Object?>>> fetchCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return maps.toList();
  }

  Future<Map<String, Object?>> fetchCategoryById(int categoryId) async {
    final db = await database;
    final maps =
        await db.query('categories', where: 'id = ?', whereArgs: [categoryId]);

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return {};
    }
  }

  Future<Map<String, Object?>> fetchCategoryByName(String categoryName) async {
    final db = await database;
    final maps = await db.query('categories',
        where: 'categoryName = ?', whereArgs: [categoryName]);

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return {};
    }
  }

  Future<List<Map<String, Object?>>> fetchItems(int categoryId) async {
    final db = await database;
    final maps = await db
        .query('items', where: 'categoryId = ?', whereArgs: [categoryId]);
    return maps.toList();
  }

  Future<List<Map<String, Object?>>> fetchItemById(int itemId) async {
    final db = await database;
    final maps = await db.query('items', where: 'id = ?', whereArgs: [itemId]);
    return maps.toList();
  }

  Future<List<Map<String, Object?>>> fetchItemByIdAndCategoryId(
      int categoryId, int itemId) async {
    final db = await database;
    final maps = await db.query('items',
        where: 'id = ? AND categoryId = ?', whereArgs: [categoryId, itemId]);
    return maps.toList();
  }

  // # new: Method to delete a category by ID
  Future<void> deleteCategory(int id) async {
    final db = await database;
    try {
      await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting category from database: $e');
      }
    }
  }

  // # new: Method to delete an item by ID
  Future<void> deleteItem(int id) async {
    final db = await database;
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting item from database: $e');
      }
    }
  }

  // # new: Method to update a category by ID
  Future<void> updateCategory(
      int id, String storeName, String categoryName) async {
    final db = await database;
    try {
      await db.update(
          'categories',
          {
            'storeName': storeName,
            'categoryName': categoryName,
          },
          where: 'id = ?',
          whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating category in database: $e');
      }
    }
  }

  // # new: Method to update an item by ID
  Future<void> updateItem(int id, String name, double price, String imagePath,
      int count, int max, int categoryId) async {
    final db = await database;
    try {
      await db.update(
          'items',
          {
            'name': name,
            'price': price,
            'imagePath': imagePath,
            'count': count,
            'max': max,
            'categoryId': categoryId,
          },
          where: 'id = ?',
          whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating item in database: $e');
      }
    }
  }
}
