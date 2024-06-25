## Flutter/Dart SQLite Database Service Documentation

This documentation provides an overview and usage guide for the SQLite database service implemented in Flutter using Dart. The database service manages categories and items, with CRUD operations.

### Overview

The database service consists of two main components:
1. **Item Class**: Represents an item with properties such as name, price, image path, count, and maximum quantity.
2. **DatabaseService Class**: Manages the SQLite database operations including creating tables, inserting, updating, fetching, and deleting categories and items.

### Item Class

#### Properties

- `String name`: Name of the item.
- `double price`: Price of the item.
- `String imagePath`: Path to the image of the item.
- `int count`: Current count of the item.
- `int max`: Maximum allowed count of the item.

#### Methods

- `Map<String, dynamic> toMap(int categoryId)`: Converts an `Item` instance to a map for database storage.
- `static String encode(List<Item> items, int categoryId)`: Encodes a list of items into a JSON string.
- `static List<Item> decode(String items)`: Decodes a JSON string back into a list of `Item` instances.
- `factory Item.fromMap(Map<String, dynamic> map)`: Creates an `Item` instance from a map.

### DatabaseService Class

#### Properties

- `Database? _db`: The SQLite database instance.
- `static final DatabaseService instance`: Singleton instance of the `DatabaseService`.

#### Methods

- `Future<Database> get database`: Returns the database instance, initializing it if necessary.
- `Future<Database> getDatabase()`: Initializes and returns the SQLite database, creating tables if necessary.
- `Future<void> addCategoryWithItems(String storeName, String categoryName, List<Item> items)`: Adds a new category along with its items to the database.
- `Future<List<Map<String, Object?>>> fetchCategories()`: Fetches all categories from the database.
- `Future<List<Map<String, Object?>>> fetchItems(int categoryId)`: Fetches all items for a specific category from the database.
- `Future<void> deleteCategory(int id)`: Deletes a category by its ID.
- `Future<void> deleteItem(int id)`: Deletes an item by its ID.
- `Future<void> updateCategory(int id, String storeName, String categoryName)`: Updates a category by its ID.
- `Future<void> updateItem(int id, String name, double price, String imagePath, int count, int max, int categoryId)`: Updates an item by its ID.

### Usage

#### Initialize Database Service

```dart
final databaseService = DatabaseService.instance;
```

#### Add Category with Items

```dart
final items = [
  Item(name: 'Item1', price: 10.0, imagePath: 'path/to/image1', count: 5, max: 10),
  Item(name: 'Item2', price: 20.0, imagePath: 'path/to/image2', count: 3, max: 5),
];

await databaseService.addCategoryWithItems( 'CategoryName', items);
```

#### Fetch Categories

```dart
List<Map<String, Object?>> categories = await databaseService.fetchCategories();
```

#### Fetch Items for a Category

```dart
List<Map<String, Object?>> items = await databaseService.fetchItems(categoryId);
```

#### Delete a Category

```dart
await databaseService.deleteCategory(categoryId);
```

#### Delete an Item

```dart
await databaseService.deleteItem(itemId);
```

#### Update a Category

```dart
await databaseService.updateCategory(categoryId, 'NewStoreName', 'NewCategoryName');
```

#### Update an Item

```dart
await databaseService.updateItem(itemId, 'NewItemName', 15.0, 'new/path/to/image', 4, 8, categoryId);
```

### Data Examples

#### Example Category Data

```json
[
  {
    "id": 1,
    "storeName": "Electronics Store",
    "categoryName": "Laptops"
  },
  {
    "id": 2,
    "storeName": "Book Store",
    "categoryName": "Fiction"
  }
]
```

#### Example Item Data

```json
[
  {
    "id": 1,
    "name": "MacBook Pro",
    "price": 2500.00,
    "imagePath": "path/to/macbookpro.jpg",
    "count": 10,
    "max": 20,
    "categoryId": 1
  },
  {
    "id": 2,
    "name": "Surface Laptop",
    "price": 1500.00,
    "imagePath": "path/to/surfacelaptop.jpg",
    "count": 5,
    "max": 10,
    "categoryId": 1
  },
  {
    "id": 3,
    "name": "The Great Gatsby",
    "price": 10.00,
    "imagePath": "path/to/greatgatsby.jpg",
    "count": 50,
    "max": 100,
    "categoryId": 2
  }
]
```

### Data Manipulation Examples

#### Adding a New Category with Items

```dart
final newItems = [
  Item(name: 'ItemA', price: 30.0, imagePath: 'path/to/imageA', count: 10, max: 50),
  Item(name: 'ItemB', price: 40.0, imagePath: 'path/to/imageB', count: 5, max: 20),
];

await databaseService.addCategoryWithItems( 'New Category', newItems);
```

#### Fetching All Categories

```dart
List<Map<String, Object?>> categories = await databaseService.fetchCategories();
for (var category in categories) {
  print('Category ID: ${category['id']}, Name: ${category['categoryName']}');
}
```

#### Fetching Items for a Specific Category

```dart
int categoryId = 1; // Example category ID
List<Map<String, Object?>> items = await databaseService.fetchItems(categoryId);
for (var item in items) {
  print('Item Name: ${item['name']}, Price: ${item['price']}');
}
```

#### Deleting a Category

```dart
int categoryId = 1; // Example category ID
await databaseService.deleteCategory(categoryId);
```

#### Deleting an Item

```dart
int itemId = 1; // Example item ID
await databaseService.deleteItem(itemId);
```

#### Updating a Category

```dart
int categoryId = 1; // Example category ID
await databaseService.updateCategory(categoryId, 'Updated Store Name', 'Updated Category Name');
```

#### Updating an Item

```dart
int itemId = 1; // Example item ID
await databaseService.updateItem(itemId, 'Updated Item Name', 2000.0, 'updated/path/to/image', 15, 30, categoryId);
```

### Error Handling

All database operations include error handling with debug mode printing errors if they occur. Ensure to run your app in debug mode during development to catch and handle any potential issues.

```dart
if (kDebugMode) {
  print('Error message');
}
```

This documentation should help you understand and utilize the SQLite database service in your Flutter application efficiently. If you have any questions or need further assistance, feel free to reach out!