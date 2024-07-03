import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/database/database.service.dart';

class CategoryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Category> categories = [];
  Map<int, List<Item>> placeholderItemsMap = {};

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

  Future<List<Item>> fetchItemByCategoryId(int categoryId) async {
    final fetchedItems = await _databaseService.fetchItemsByCategoryId(categoryId);
    return fetchedItems.map((itemData) => Item.fromMap(itemData)).toList();
  }

  void addNewCat({
    required List<Item> newItems,
    required String newCategoryNames,
  }) async {
    await _databaseService.addCategoryWithItems(newCategoryNames, newItems);
    _initializeCategories();
  }

  void removeCategory(int index) {
    final categoryId = categories[index].id;
    _databaseService.deleteCategory(categoryId);
    categories.removeAt(index);
    placeholderItemsMap.remove(categoryId);
    notifyListeners();
  }

  void removeItem(int categoryIndex, int itemIndex) {
    final categoryId = categories[categoryIndex].id;
    if (placeholderItemsMap.containsKey(categoryId)) {
      placeholderItemsMap[categoryId]!.removeAt(itemIndex);
      notifyListeners();
    }
  }

  void addItemToPlaceholder(int categoryIndex, Item newItem) {
    final categoryId = categories[categoryIndex].id;
    if (!placeholderItemsMap.containsKey(categoryId)) {
      placeholderItemsMap[categoryId] = [];
    }
    placeholderItemsMap[categoryId]!.add(newItem);
    notifyListeners();
  }

  List<Item> getPlaceholderItems(int categoryIndex) {
    final categoryId = categories[categoryIndex].id;
    return placeholderItemsMap[categoryId] ?? [];
  }

  void fetchDatabase() async {
    List categoriesFromDb = await _databaseService.fetchCategories();
    List itemsFromDb = await _databaseService.fetchItems();
    if (kDebugMode) {
      print(categoriesFromDb.toList());
      print(itemsFromDb.toList());
    }
    notifyListeners();
  }

  Future<List<Category>> fetchCategory() async {
    List categoriesFromDb = await _databaseService.fetchCategories();
    return categoriesFromDb.map((categoryData) {
      final categoryId = categoryData['id'] as int;
      final categoryItems = categories
          .firstWhere((category) => category.id == categoryId)
          .items;
      return Category(
        id: categoryId,
        name: categoryData['categoryName'] as String,
        items: categoryItems,
      );
    }).toList();
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
