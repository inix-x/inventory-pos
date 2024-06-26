import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/global/common/toast.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart' as category_provider;
import 'package:provider/provider.dart';

class AddItemspage extends StatefulWidget {
  final int itemIndex;
  final String catName;
  final List<Item> items;

  const AddItemspage({
    super.key,
    required this.itemIndex,
    required this.catName,
    required this.items,
  });

  @override
  State<AddItemspage> createState() => _AddItemspageState();
}

class _AddItemspageState extends State<AddItemspage> {
  void showInputDialog() async {
    final itemNameController = TextEditingController();
    final itemPriceController = TextEditingController();
    final itemCountController = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    final DatabaseService _databaseService = DatabaseService.instance;

    final categoryProvider = context.read<category_provider.CategoryProvider>();
    final category = categoryProvider.categories[widget.itemIndex];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: itemNameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter item name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: itemPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter item price',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: itemCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter item stock',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final itemName = itemNameController.text;
                final itemPrice = double.parse(itemPriceController.text);
                final itemStock = int.parse(itemCountController.text);
                final newItem = Item(
                  name: itemName,
                  price: itemPrice,
                  imagePath: '',
                  count: itemStock,
                  max: 10,
                );

                // Fetch the categoryId using the category name
                final categoryId = await _databaseService.fetchCategoryIdByName(category.name);

                if (categoryId != -1) {
                  // Add item to database with fetched categoryId
                  await _databaseService.addItems(categoryId, [newItem]);

                  // Fetch and print stored data
                  final storedData = await _databaseService.fetchCategories();
                  if (kDebugMode) {
                    print('--- Stored Data in Database ---');
                    for (var data in storedData) {
                      print(data);
                    }
                  }
                  final storedItems = await _databaseService.fetchItems();
                  if (kDebugMode) {
                    print('--- Stored Data in Database ---');
                    for (var data in storedItems) {
                      print(data);
                    }
                  }

                  showToast(message: 'Item Successfully Saved');

                  // Update the items in the provider
                  setState(() {
                    categoryProvider.categories[widget.itemIndex].items.add(newItem);
                  });
                } else {
                  showToast(message: 'Category not found');
                }

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(int index) async {
    final categoryProvider = context.read<category_provider.CategoryProvider>();
    final item = categoryProvider.categories[widget.itemIndex].items[index];

    // ignore: no_leading_underscores_for_local_identifiers
    final DatabaseService _databaseService = DatabaseService.instance;
    await _databaseService.deleteItem(item.id!);

    setState(() {
      categoryProvider.categories[widget.itemIndex].items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = context.watch<category_provider.CategoryProvider>().categories[widget.itemIndex].name;
    final items = context.watch<category_provider.CategoryProvider>().categories[widget.itemIndex].items;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(category),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            items.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _removeItem(index),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(item.name),
                                    Text('Price: ${item.price.toString()}'),
                                    Text('Stocks: ${item.count.toString()}'),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _removeItem(index),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Text('Please add items for $category'),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              onPressed: showInputDialog,
              child: const Text('Add items'),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
