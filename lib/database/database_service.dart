import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_application_1/providers/categoryprovider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// ignore: unnecessary_import
import 'package:sqflite/sqlite_api.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _menuTableName = "menu";
  final String _menuIdColumnName = "id";
  final String _menuStoreNameContent = "storeNameContent";
  final String _menuCategoryNameContent = "CategoryNameContent";
  final String _menuItemsListContent = "ItemsListContent";
  final String _menuStatusColumn = "status";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }


//open database
Future<Database> getDatabase() async {
  final databaseDirPath = await getDatabasesPath();
  final databasePath = join(databaseDirPath, 'master_db.db');
  final database = await openDatabase(databasePath, version: 1, onCreate: (db, version) async {
   await db.execute('''
      CREATE TABLE $_menuTableName (
        $_menuIdColumnName INTEGER PRIMARY KEY, 
        $_menuStoreNameContent TEXT NOT NULL, 
        $_menuCategoryNameContent TEXT NOT NULL,  
        $_menuItemsListContent TEXT NOT NULL, 
        $_menuStatusColumn INTEGER NOT NULL
      )
    ''');
  });
  return database;
}

//adding data to database
void addToDatabase(String storeName, String name, List<Item> items) async {
  try {
    final db = await database;
    final encodedItems = jsonEncode(items); // Encode List as JSON string
    await db.insert(_menuTableName, {
      _menuStoreNameContent: storeName,
      _menuCategoryNameContent: name,
      _menuItemsListContent: encodedItems,
      _menuStatusColumn: 0,
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error adding data to database: $e');
    }
  }
}

//fetching data for output
Future<List<Category>> fetchData() async {
  final db = await DatabaseService.instance.database;
  final maps = await db.query('menu');
   return maps.cast<Category>(); // Cast the list to List<Category>
}

// Future<List<Map<String, Object?>>> fetchData() async{
//   final db = await database;
//   final data = await db.query(_menuTableName);
//   if (kDebugMode) {
//     print(data);
//   }
//   return data;
// }
}
