import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/database/database.service.dart';

// Provider
class CategoryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Category> categories = [];

  CategoryProvider({required List categories}) {
    _initializeCategories();
  }

  void _initializeCategories() async {
    final fetchedCategories = await _databaseService.fetchCategories();
    final fetchedItems = await _databaseService.fetchItems();

    if (fetchedCategories.isNotEmpty) {
      categories = fetchedCategories.map((categoryData) {
        final categoryId = categoryData['id'] as int;
        final categoryItems = fetchedItems
            .where((itemData) => itemData['categoryId'] == categoryId)
            .map((itemData) => Item.fromMap(itemData))
            .toList();

        return Category(
          id: categoryId,
          name: categoryData['categoryName'] as String,
          items: categoryItems,
        );
      }).toList();
    }

    notifyListeners();
  }

  void addNewCat({
    required List<Item> newItems,
    required String newCategoryNames,
  }) async {
    // Save to the database
    await _databaseService.addCategoryWithItems(newCategoryNames, newItems);

    // Fetch the updated list of categories from the database
    _initializeCategories();
  }

  void removeCategory(int index) {
    final categoryId = categories[index].id;
    _databaseService.deleteCategory(categoryId);
    categories.removeAt(index);
    notifyListeners();
  }

void removeItem(int categoryIndex, int itemIndex) async {
  final category = categories[categoryIndex];
  final item = category.items[itemIndex];

  if (item.id != null) {
    await _databaseService.deleteItem(item.id!);
    category.items.removeAt(itemIndex);
    notifyListeners();
  } else {
    if (kDebugMode) {
      print('Item ID is null, cannot remove item from database');
    }
  }
}


  void fetchDatabase() async {
    List categoriesFromDb = await _databaseService.fetchCategories();
    if (kDebugMode) {
      print(categoriesFromDb.toList());
    }
    notifyListeners();
  }
}

class Category {
  final int id;
  final String name;
  final List<Item> items;

  Category({
    required this.id,
    required this.name,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((item) => item.toJson()).toList(),
      };
}
