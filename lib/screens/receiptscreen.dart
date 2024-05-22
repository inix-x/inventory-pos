import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class ReceiptScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final double change;
  
  const ReceiptScreen({super.key, required this.selectedItems, required this.change});
  
  

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
    double total = 0.0;
    void calculateTotalPrice() {
    total = 0.0; // Reset total before recalculating

    for (var item in widget.selectedItems) {
      total += item["price"] * item["count"];
    }
  }

  String generateReceiptText() {
    String receiptText = "Your Order:\n\n";
    for (var item in widget.selectedItems) {
      receiptText += "${item["name"]} x ${item["count"]} - \$${item["price"] * item["count"]}\n";
    }
    receiptText += "\nTotal: \$${total.toStringAsFixed(2)}\n";
    if (widget.change >= 0) {
      receiptText += "Change: \$${widget.change.toStringAsFixed(2)}\n";
    }
    return receiptText;
  }

  void shareReceipt() {
    String receiptText = generateReceiptText();
    Share.share(receiptText);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 90),
          child: Text('Receipt',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back on press
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Order:',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                generateReceiptText(),
                textAlign: TextAlign.left,
              ),
            ),
            ElevatedButton(
              onPressed: shareReceipt,
              child: const Text('Share Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}
