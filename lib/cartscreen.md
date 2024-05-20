import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  const CartScreen(
      {super.key, required this.selectedItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
   double total = 0.0;

  void calculateTotalPrice() {
    total = 0.0; // Reset total before recalculating

    for (var item in widget.selectedItems) {
      total += item["price"] * item["count"];
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalPrice(); 
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0, right: 70, left: 70, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('My Cart'),
              SizedBox(
                width: 25,
              ),
              Icon(Icons.shopping_cart_outlined),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
              color: Colors.green,
              child: ListView.builder(
                    itemCount: widget.selectedItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.selectedItems[index];
                    
                      return Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween, // Distribute evenly
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      // color: Colors.pink,
                                      ),
                                  child: Text('Qty: ${item["count"]}')),
                              //Item Name
                              Container(
                                margin: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                    // color: Colors.green,
                                    ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["text"],
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    const Text(
                                      "Variant",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                              //Item Variant
                  
                              //Price
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 8, right: 10, bottom: 8),
                                  decoration: const BoxDecoration(
                                      // x
                                      ),
                                  child: Text('\$${item["price"]}')),
                              //Checkout
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
      ),
      bottomNavigationBar: 
          Container(
            color: Colors.blueAccent,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total : '),
              Text('\$${total.toStringAsFixed(2)}'), // Display total with 2 decimal places
              Container(
                color: Colors.white,
                child: MaterialButton(onPressed: (){},
                child: const Text('Checkout'),),
              )
              ],
              ),
          ),
    );
  }
}
