// database.service.dart

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Item {
  final int? id;
  final String name;
  final double price;
  final String imagePath;
  final int count;
  final int max;

  Item({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.count,
    required this.max,
  });

  Map<String, dynamic> toMap(int categoryId) {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'count': count,
      'max': max,
      'categoryId': categoryId,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as double,
      imagePath: map['imagePath'] as String,
      count: map['count'] as int,
      max: map['max'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imagePath': imagePath,
        'count': count,
        'max': max,
      };
}

class SelectedItems {
  final int? id;
  final String name;
  final double price;
  final String imagePath;
  late  int count;
  late  int max;

  SelectedItems({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.count,
    required this.max,
  });

  Map<String, dynamic> toMap(int categoryId) {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'count': count,
      'max': max,
      'categoryId': categoryId,
    };
  }

  factory SelectedItems.fromMap(Map<String, dynamic> map) {
    return SelectedItems(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as double,
      imagePath: map['imagePath'] as String,
      count: map['count'] as int,
      max: map['max'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imagePath': imagePath,
        'count': count,
        'max': max,
      };
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
    final database = await openDatabase(databasePath, version: 2,
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
        max INTEGER NOT NULL,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
    });
    return database;
  }

  // Future<Database> getDatabase() async {
  //   final databaseDirPath = await getDatabasesPath();
  //   final databasePath = join(databaseDirPath, 'master_db.db');
  //   final database = await openDatabase(databasePath, version: 2, onCreate: (db, version) async {
  //     await db.execute('''
  //       CREATE TABLE categories (
  //         id INTEGER PRIMARY KEY AUTOINCREMENT,
  //         categoryName TEXT NOT NULL
  //       )
  //     ''');
  //     await db.execute('''
  //       CREATE TABLE items (
  //         id INTEGER PRIMARY KEY AUTOINCREMENT,
  //         name TEXT NOT NULL,
  //         price REAL NOT NULL,
  //         imagePath TEXT,
  //         count INTEGER NOT NULL,
  //         max INTEGER NOT NULL,
  //         categoryId INTEGER NOT NULL,
  //         FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
  //       )
  //     ''');
  //   },
  //   onUpgrade: (db, oldVersion, newVersion) async {
  //     if (oldVersion < 2) {
  //       await db.execute('ALTER TABLE items ADD COLUMN max INTEGER NOT NULL DEFAULT 10');
  //     }
  //   });
  //   return database;
  // }

  // Add this method to the DatabaseService class in database.service.dart

  // Add this method to the DatabaseService class in database.service.dart

  Future<void> updateItemCount(List<SelectedItems> selectedItems) async {
  final db = await database;
  
  try {
    await db.transaction((txn) async {
      for (var selectedItem in selectedItems) {
        var result = await txn.query(
          'items',
          columns: ['id', 'count', 'max'],
          where: 'id = ?',
          whereArgs: [selectedItem.id],
        );
        
        if (result.isNotEmpty) {
          int currentCount = result.first['count'] as int;
          
          // Calculate the new count after subtraction
          int newCount = currentCount - selectedItem.max;
          
          // Ensure count doesn't go below zero
          newCount = newCount < 0 ? 0 : newCount;
          
          // Update the item count in the database
          await txn.update(
            'items',
            {'count': newCount},
            where: 'id = ?',
            whereArgs: [selectedItem.id],
          );
        }
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error updating item counts in database: $e');
    }
  }
}


  //fetch the items from db items to selectedItems list
  Future<List<SelectedItems>> fetchSelectedItems() async {
    final db = await database;
    final maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return SelectedItems.fromMap(maps[i]);
    });
  }

  Future<bool> isItemCountGreaterThanZero(int itemId) async {
    final db = await database;
    final result = await db.query(
      'items',
      columns: ['count'],
      where: 'id = ?',
      whereArgs: [itemId],
    );

    if (result.isNotEmpty) {
      final count = result.first['count'] as int;
      return count > 0;
    }
    return false;
  }

  Future<void> addCategoryWithItems(
      String categoryName, List<Item> items) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        int categoryId =
            await txn.insert('categories', {'categoryName': categoryName});
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
        if (items.isNotEmpty && !(categoryId.isNaN)) {
          for (var item in items) {
            await txn.insert('items', item.toMap(categoryId));
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding items to database: $e');
      }
    }
  }

  Future<Map<String, Object?>?> addCategory(String categoryName) async {
    final db = await database;
    try {
      int categoryId = -1;
      await db.transaction((txn) async {
        categoryId =
            await txn.insert('categories', {'categoryName': categoryName});
      });

      if (categoryId != -1) {
        final List<Map<String, Object?>> maps = await db
            .query('categories', where: 'id = ?', whereArgs: [categoryId]);
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

  Future<List<Map<String, Object?>>> fetchItems() async {
    final db = await database;
    final maps = await db.query('items');
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

  Future<Map<String, Object?>> fetchCategoryByNameChecker(
      String categoryName) async {
    final db = await database;
    final maps = await db.query('categories',
        where: 'categoryName = ?', whereArgs: [categoryName]);

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return {};
    }
  }

  Future<int> fetchCategoryIdByName(String categoryName) async {
    final db = await database;
    final maps = await db.query('categories',
        columns: ['id'], where: 'categoryName = ?', whereArgs: [categoryName]);

    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    } else {
      return -1;
    }
  }

  Future<bool> itemExists(String name) async {
    final db = await instance.database;
    final result = await db.query(
      'items',
      columns: ['name'],
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, Object?>>> fetchItemById(int itemId) async {
    final db = await database;
    final maps = await db.query('items', where: 'id = ?', whereArgs: [itemId]);
    return maps.toList();
  }

  Future<List<Map<String, Object?>>> fetchItemsByCategoryId(
      int categoryId) async {
    final db = await database;
    final maps = await db
        .query('items', where: 'categoryId = ?', whereArgs: [categoryId]);
    return maps.toList();
  }

  Future<void> updateCategory(int categoryId, String newCategoryName) async {
    final db = await database;
    await db.update('categories', {'categoryName': newCategoryName},
        where: 'id = ?', whereArgs: [categoryId]);
  }

  Future<void> updateItem(int itemId, Item updatedItem) async {
    final db = await database;
    await db.update('items', updatedItem.toMap(updatedItem.id ?? 0),
        where: 'id = ?', whereArgs: [itemId]);
  }

  Future<void> deleteCategory(int categoryId) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [categoryId]);
  }

  Future<void> deleteItem(int itemId) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [itemId]);
  }
}
