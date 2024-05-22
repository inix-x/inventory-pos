import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  const PaymentScreen({super.key, required this.selectedItems});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double total = 0.0;

  void calculateTotalPrice() {
    total = 0.0; // Reset total before recalculating

    for (var item in widget.selectedItems) {
      total += item["price"] * item["count"];
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalPrice(); //calculate the total price of the selectedItems.
    return Scaffold(
      appBar: AppBar(
          title: Padding(
        padding: const EdgeInsets.only(left: 90),
        child: Text('Order #',
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      )

          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   // Ensure you're using the correct navigation context
          //   onPressed: () => Navigator.pop(context), // Navigate back on press
          // ),
          ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Your Total is: \$${total.toStringAsFixed(2)}',
                  style: GoogleFonts.raleway(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                 SizedBox(
                  width: 300,
                  child: TextField(
                    keyboardType:
                        TextInputType.number, // Display numeric keyboard
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits 0-9
                    ],
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Payment Amount',
                    ),
                  ),
                ),
                Container(
                    height: 100,
                    width: 300,
                    color: Colors.green,
                    child: MaterialButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cash',
                            style: GoogleFonts.raleway(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.attach_money_sharp),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const DottedLine(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      dashLength: 5,
                      lineLength: 100,
                      lineThickness: 1.0,
                      dashColor: primaryColor,
                    ),
                    Text(
                      'OR',
                      style: GoogleFonts.oswald(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const DottedLine(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      dashLength: 5,
                      lineLength: 100,
                      lineThickness: 1.0,
                      dashColor: primaryColor,
                    ),
                  ],
                ),
                Container(
                    height: 100,
                    width: 300,
                    color: Colors.blue,
                    child: MaterialButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Card',
                            style: GoogleFonts.raleway(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.credit_card_sharp),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
