import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart';
import 'package:provider/provider.dart';

class AddItemspage extends StatefulWidget {
  final int itemIndex;

  const AddItemspage({super.key, required this.itemIndex});

  @override
  State<AddItemspage> createState() => _AddItemspageState();
}

class _AddItemspageState extends State<AddItemspage> {
  void showInputDialog() async{
    final itemNameController = TextEditingController();
    final itemPriceController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            children: [
              TextField(
                controller: itemNameController,
                decoration: const InputDecoration(hintText: 'Enter item name'),
              ),
              TextField(
                controller: itemPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter item price'),
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
                final itemPrice = double.parse(itemPriceController.text);
                final newItem = Item(
                  name: itemName,
                  price: itemPrice,
                  imagePath: '',
                  count: 0,
                  max: 10,
                );
                context
                    .read<CategoryProvider>()
                    .categories[widget.itemIndex]
                    .items
                    .add(newItem);
                Navigator.pop(context);
                 setState(() {});
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
    void _removeItem(int index) {
    // Get the CategoryProvider instance using Provider.of
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    // Remove the category at the specified index from the provider
    categoryProvider.removeItem(index);
    // No need to modify _categories (local list) or setState
  } 

  @override
  Widget build(BuildContext context) {
    final category = context.watch<CategoryProvider>().categories[widget.itemIndex].name;
    final items = context.watch<CategoryProvider>().categories[widget.itemIndex].items;

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
            items.isNotEmpty ? ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                 final item = items[index];
                  return Dismissible(
                    // Set a unique key for each item
                    key: ValueKey(item.name),
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed:(_)=> _removeItem(index),
                    child: Card(
                      child: Padding(
                        padding:  const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(item.name),
                                Text(item.price.toString()),
                              ],
                            ),
                            IconButton(
                                      icon:  const Icon(Icons.delete),
                                      onPressed: () => _removeItem(index),
                                    ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ) :  Text('Please add items for $category'),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: showInputDialog,
              child: const Text('Add items'),
            ),
              
          ],
        ),
      ),
    );
  }
}
