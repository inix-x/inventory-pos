import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/screens/paymentscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  const CartScreen({super.key, required this.selectedItems});

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

  void navigateToPaymentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  PaymentScreen( selectedItems : widget.selectedItems )),
    );
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalPrice();
    return Scaffold(
      appBar: AppBar(
        title:  Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 70, left: 60, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Order Details' , style: GoogleFonts.lato(),),
              const SizedBox(
                width: 25,
              ),
              
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: widget.selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.selectedItems[index];

                    return Card(
                      elevation: 12,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity
                            Container(
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  // color: Colors.pink, // Optional background color
                                  ),
                              child: Text(
                                'Qty: ${item["count"] ?? 0}', // Use null-ish coalescing operator
                                style:  GoogleFonts.raleway(
                                  textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                )
                              ),
                            ),

                            // Item Details
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                  // color: Colors.green, // Optional background color
                                  ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    item["name"] ??
                                        "", // Use null-ish coalescing operator
                                    style:  GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    )
                                  ),
                                   Text(
                                    "Variant",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    )
                                  ),
                                ],
                              ),
                            ),

                            // Price
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 8, right: 10, bottom: 8),
                              decoration: const BoxDecoration(
                                  // color: Colors.blue, // Optional background color
                                  ),
                              child: Text(
                                '\$${item["price"]?.toStringAsFixed(2) ?? 0.0}', // Use null-safe navigation and null-ish coalescing operator
                                style:  GoogleFonts.raleway(
                                  textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 70,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                       Text('Total :',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(color: Colors.white)
                          )
                          ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(color: Colors.white, fontSize: 16)
                        ),
                      ), // Display total with 2 decimal places
                      const SizedBox(
                        width: 15,
                      ),
                      const DottedLine(
                        direction: Axis.vertical,
                        alignment: WrapAlignment.center,
                        dashLength: 5,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashColor: accentColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, top: 8, bottom: 8),
                        child: Container(
                            color: primaryColor,
                            child: MaterialButton(
                              onPressed: navigateToPaymentScreen,
                              child:  Text(
                                'Process Transaction',
                                style: GoogleFonts.quattrocento(
                                  textStyle: const TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.bold),
                                )
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
