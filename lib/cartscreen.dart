import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedItems;

  const CartScreen({super.key, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ListView.builder(
        itemCount: selectedItems.length,
        itemBuilder: (context, index) {
          final item = selectedItems[index];
          return ListTile(
            title: Text(item["text"]),
            subtitle: Text('Price: \$${item["price"]}, Count: ${item["count"]}'),
          );
        },
      ),
    );
  }
}
