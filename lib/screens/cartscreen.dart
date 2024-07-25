import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/providers/themeprovider.dart';
import 'package:flutter_application_1/screens/paymentscreen.dart';
import 'package:flutter_application_1/themes/settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final List<SelectedItems> selectedItems;
  const CartScreen({super.key, required this.selectedItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double total = 0.0;

  void calculateTotalPrice() {
    total = 0.0; // Reset total before recalculating

    for (var item in widget.selectedItems) {
      total += item.price * item.max;
    }

    if (kDebugMode) {
      for (var item in widget.selectedItems) {
        print(
            'Item: ${item.name}, Price: ${item.price}, Quantity: ${item.max}');
      }
    }
  }

  void navigateToPaymentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentScreen(selectedItems: widget.selectedItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context, listen: false);
    calculateTotalPrice();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text('Order Details',
                  style: Theme.of(context).textTheme.displayMedium),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  SettingsDialog.show(context);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: widget.selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.selectedItems[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Item Details
                              Container(
                                margin: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Variant",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity
                              Container(
                                margin: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(),
                                child: Text(
                                  'Qty: ${item.max}',
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                ),
                              ),
                              // Price
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 8, right: 10, bottom: 8),
                                decoration: const BoxDecoration(),
                                child: Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Total :',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Container(
            color: Colors.blueAccent,
            child: MaterialButton(
              onPressed: navigateToPaymentScreen,
              child: Text(
                'Process Transaction',
                style: GoogleFonts.quattrocento(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
        );
  }
}
