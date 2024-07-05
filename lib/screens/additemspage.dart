import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/global/common/toast.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart'
    as category_provider;
import 'package:provider/provider.dart';

class AddItemspage extends StatefulWidget {
  final int itemIndex;
 
  final List<Item> items;

  const AddItemspage({
    super.key,
    required this.itemIndex,
  
    required this.items,
  });

  @override
  State<AddItemspage> createState() => _AddItemspageState();
}

class _AddItemspageState extends State<AddItemspage> {
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Only numbers and decimal point
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter item price',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: itemCountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Only digits allowed
              ],
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
              final itemName = itemNameController.text.trim();
              final itemPriceText = itemPriceController.text.trim();
              final itemCountText = itemCountController.text.trim();

              // Regular expression to check for alphabets and spaces only
              final validItemName = RegExp(r'^[a-zA-Z\s]+$');

              if (itemName.isEmpty) {
                showToast(message: 'Item name cannot be empty');
              } else if (!validItemName.hasMatch(itemName)) {
                showToast(message: 'Item name can only contain letters and spaces');
              } else if (itemPriceText.isEmpty) {
                showToast(message: 'Item price cannot be empty');
              } else if (itemCountText.isEmpty) {
                showToast(message: 'Item count cannot be empty');
              } else {
                try {
                  final itemPrice = double.parse(itemPriceText);
                  final itemStock = int.parse(itemCountText);

                  // Check if item price is a positive number
                  if (itemPrice <= 0) {
                    showToast(message: 'Item price must be greater than 0');
                  } else if (itemStock <= 0) {
                    showToast(message: 'Item count must be greater than 0');
                  } else {
                    // ignore: no_leading_underscores_for_local_identifiers
                    final DatabaseService _databaseService = DatabaseService.instance;
                    final itemExists = await _databaseService.itemExists(itemName);

                    if (itemExists) {
                      showToast(message: 'The item already exists');
                    } else {
                      final newItem = Item(
                        name: itemName,
                        price: itemPrice,
                        imagePath: '',
                        count: itemStock,
                        max: 10,
                      );

                      categoryProvider.addItemToPlaceholder(widget.itemIndex, newItem);

                      if (mounted) {
                        setState(() {
                          isSaved = false;
                        });
                      }
                      showToast(message: 'Please save the items first.');
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  }
                } catch (e) {
                  showToast(message: 'Invalid input for price or count');
                }
              }
            },
            child: const Text('Save Item'),
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

    final categoryId =
        await _databaseService.fetchCategoryIdByName(category.name);

    if (categoryId != -1) {
      final placeholderItems =
          categoryProvider.getPlaceholderItems(widget.itemIndex);

      for (var item in placeholderItems) {
        await _databaseService.addItems(categoryId, [item]);
      }

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

      if (mounted) {
        setState(() {
          categoryProvider.categories[widget.itemIndex].items
              .addAll(placeholderItems);
          isSaved = true;
        });

        Navigator.pop(context);
      }
    } else {
      showToast(message: 'Category not found');
    }
  }

  void _removeItem(int index) {
    final categoryProvider = context.read<category_provider.CategoryProvider>();
    categoryProvider.removeItem(widget.itemIndex, index);
  }

  Future<bool> _onWillPop() async {
    if (!isSaved) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                  'There are items that are not saved to the database'),
              content: const Text('Would you like to save your items?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    saveItemsDb();
                    setState(() {
                      isSaved = true;
                    });
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        context.watch<category_provider.CategoryProvider>();
    final category = categoryProvider.categories[widget.itemIndex];
    final placeholderItems =
        categoryProvider.getPlaceholderItems(widget.itemIndex);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: isSaved ? true : false,
          title: Row(
            mainAxisAlignment:
                isSaved ? MainAxisAlignment.start : MainAxisAlignment.center,
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
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => _removeItem(index),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(item.name),
                                        Text('Price: ${item.price.toString()}'),
                                        Text(
                                            'Stocks: ${item.count.toString()}'),
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
      ),
    );
  }
}
