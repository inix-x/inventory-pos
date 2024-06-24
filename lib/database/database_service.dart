import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_application_1/providers/categoryprovider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _menuTableName = "menu";
  final String _menuIdColumnName = "id";
  final String _menuCategoryNameContent = "CategoryNameContent";
  final String _menuItemsListContent = "ItemsListContent";
  final String _menuStatusColumn = "status";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  // Open database
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'master_db.db');
    final database = await openDatabase(databasePath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $_menuTableName (
          $_menuIdColumnName INTEGER PRIMARY KEY, 
          $_menuCategoryNameContent TEXT NOT NULL,  
          $_menuItemsListContent TEXT NOT NULL, 
          $_menuStatusColumn INTEGER NOT NULL
        )
      ''');
    });
    return database;
  }

  // Adding item to database
  Future<void> addItemToDatabase(String name, Item item) async {
    try {
      final db = await database;
      final encodedItem = jsonEncode(item.toJson()); // Encode Item as JSON string
      await db.insert(_menuTableName, {
        _menuCategoryNameContent: name,
        _menuItemsListContent: encodedItem,
        _menuStatusColumn: 0,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding data to database: $e');
      }
    }
  }

  // Fetching data for output
  Future<List<Map<String, Object?>>> fetchData() async {
    final db = await DatabaseService.instance.database;
    final maps = await db.query(_menuTableName);
    return maps.toList(); // Return the list of maps
  }
}
