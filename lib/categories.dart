// Import the Category class from categories.dart

// Use the categories list directly
 List<Category> categories = [
  Category(
    name: "Entree",
    items: [
      Item(
        name: "Pizza",
        price: 10.00,
        imagePath: "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        count: 0, // Initial count
        max: 10,  // Maximum allowed
      ),
      Item(
        name: "Burger",
        price: 12.00,
        imagePath: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1998&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        count: 0,
        max: 10,
      ),
      Item(
        name: "Pasta",
        price: 8.00,
        imagePath: "https://images.unsplash.com/photo-1598866594230-a7c12756260f?q=80&w=2016&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        count: 0,
        max: 10,
      ),
    ],
  ),

  // Add more categories and items as needed
];

class Category {
  final String name;
  final List<Item> items;

  Category({required this.name, required this.items});
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
}
