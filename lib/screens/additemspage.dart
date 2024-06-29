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
  //do not allow user to go back until the items in each category is saved
  bool isSaved = true;
  void showInputDialog() async {
    final itemNameController = TextEditingController();
    final itemPriceController = TextEditingController();
    final itemCountController = TextEditingController();

    final categoryProvider = context.read<category_provider.CategoryProvider>();
    
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
              onPressed: () {
                final itemName = itemNameController.text;
                if (itemName.isNotEmpty &&
                    itemPriceController.text.isNotEmpty &&
                    itemCountController.text.isNotEmpty) {
                  final itemPrice = double.parse(itemPriceController.text);
                  final itemStock = int.parse(itemCountController.text);
                  final newItem = Item(
                    name: itemName,
                    price: itemPrice,
                    imagePath: '',
                    count: itemStock,
                    max: 10,
                  );

                  // Add item to the placeholder list
                  categoryProvider.addItemToPlaceholder(widget.itemIndex, newItem);

                  //RESET the isSaved Bool if there's a new Item to prompt the user to save before going back
                  setState(() {
                    isSaved = false;
                  });
                  showToast(message: 'Please save the items first.');
                  Navigator.pop(context);
                } else {
                  showToast(message: 'Please fill in all fields');
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void saveItemsDb() async {
    final categoryProvider = context.read<category_provider.CategoryProvider>();
    final category = categoryProvider.categories[widget.itemIndex];
    // ignore: no_leading_underscores_for_local_identifiers
    final DatabaseService _databaseService = DatabaseService.instance;

    // Fetch the categoryId using the category name
    final categoryId = await _databaseService.fetchCategoryIdByName(category.name);

    if (categoryId != -1) {
      final placeholderItems = categoryProvider.getPlaceholderItems(widget.itemIndex);

      // Add each item to the database with fetched categoryId from the placeholder
      for (var item in placeholderItems) {
        await _databaseService.addItems(categoryId, [item]);
      }

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

      showToast(message: 'Items Successfully Saved');

      // Update the items in the provider
      setState(() {
        categoryProvider.categories[widget.itemIndex].items.addAll(placeholderItems);
        isSaved = true;
      });
    } else {
      showToast(message: 'Category not found');
    }
  }

  void _removeItem(int index) {
    final categoryProvider = context.read<category_provider.CategoryProvider>();
    categoryProvider.removeItem(widget.itemIndex, index);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<category_provider.CategoryProvider>();
    final category = categoryProvider.categories[widget.itemIndex];
    final placeholderItems = categoryProvider.getPlaceholderItems(widget.itemIndex);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isSaved ? true : false,
        title: Row(
          mainAxisAlignment: isSaved ? MainAxisAlignment.start : MainAxisAlignment.center,

          children: [
            Text(category.name),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            placeholderItems.isNotEmpty
                ? Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: placeholderItems.length,
                      itemBuilder: (context, index) {
                        final item = placeholderItems[index];
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
                                    onPressed: () {
                                      _removeItem(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                )
                : Text('Please add items for ${category.name}'),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              onPressed: saveItemsDb,
              child: const Text('Save items'),
            ),
          ],
        ),
      ),
    );
  }
}