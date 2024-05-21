// Import the Category class from categories.dart
import 'package:flutter_application_1/cartscreen.dart';
import 'package:flutter_application_1/categories.dart';

// Import widgets for building the UI
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class SelectedItem {
  final String name;
  final double price;
  int count;

  SelectedItem({required this.name, required this.price, required this.count});

  // Add a method to convert to Map
  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'count': count,
      };
}

class _MenuScreenState extends State<MenuScreen> {
  List<SelectedItem> selectedItems = []; // New list to store selected items
  // Add a method to update the count of an item
  void updateItemCount(Item item, int change) {
    setState(() {
      item.count += change;
      // Implement logic to handle max limit (optional)
      if (item.count > item.max) {
        item.count = item.max; // Reset to max if exceeded
      } else if (item.count < 0) {
        item.count = 0; // Reset to 0 if negative
      }
    });
  }
  
  void addSelectedItem(Item item) {
  // ignore: collection_methods_unrelated_type
  final existingItem = selectedItems.contains((selectedItem) => selectedItem.name == item.name);
  if (existingItem) {
    // Update count for existing item
    setState(() {
      final itemToUpdate = selectedItems.firstWhere((selectedItem) => selectedItem.name == item.name);
      itemToUpdate.count += item.count;
    });
  } else {
    // Add new item with its count
    setState(() {
      selectedItems.add(SelectedItem(name: item.name, price: item.price, count: item.count));
    });
  }
}

void reduceSelectedItems(Item item) {
  final existingItem = selectedItems.firstWhere((selectedItem) => selectedItem.name == item.name);
  setState(() {
    if (existingItem.count > 1) {
      existingItem.count--;
    } else {
      selectedItems.remove(existingItem);
    }
  });
}


double calculateTotalPrice(List<SelectedItem> selectedItems) {
  double totalPrice = 0.0;
  for (final item in selectedItems) {
    totalPrice += item.price * item.count;
  }
  return totalPrice;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: categories
              .map((category) => buildCategoryContainer(category))
              .toList(),
        ),
      ),
      floatingActionButton: Theme(
  data: Theme.of(context).copyWith(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      extendedSizeConstraints: BoxConstraints.tightFor(height: 60),
    ),
  ),
  child: FloatingActionButton.extended(
    icon: const Icon(Icons.shopping_basket),
    label: Text(
      // Update label with counter and totalPrice (assuming they are defined elsewhere)
      'Your ${selectedItems.fold(0, (sum, item) => sum + item.count)} Added Items  \$${calculateTotalPrice(selectedItems)}',
    ),
    onPressed: () {
      if (selectedItems.isNotEmpty) {
         final convertedItems = selectedItems.map((item) => item.toMap()).toList();
    // Navigate to CartScreen with converted items
        // Navigate to CartScreen with selected items
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartScreen(
              selectedItems: convertedItems,
            ),
          ),
        );
        // ignore: avoid_print
        print('$convertedItems');
      } else {
        // Show alert dialog if cart is empty
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cart is Empty'),
            content: const Text(
                'Please add items to your cart before proceeding.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    },
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
)
,
    );
  }

  Widget buildCategoryContainer(Category category) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      height: 480,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          buildItemList(category.items), // Call function to build dynamic list
        ],
      ),
    );
  }

  Widget buildItemList(List<Item> items) {
    return ListView.builder(
      shrinkWrap: true, // Prevent list from overflowing
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return buildItemCard(item);
      },
    );
  }

  Widget buildItemCard(Item item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Display image (optional)
            Image.network(
              item.imagePath,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name),
                  const SizedBox(height: 4.0),
                  Text('\$${item.price.toStringAsFixed(2)}'), // Format price
                ],
              ),
            ),

            // Display and update item count (optional)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    updateItemCount(item, -1);
                    reduceSelectedItems(item);
                  }
                ),
                Text(item.count.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    updateItemCount(item, 1);
                    addSelectedItem(item);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
