import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class ReceiptScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final double change;
  final screenshotController = ScreenshotController();
   // New variable for screenshot

  ReceiptScreen({super.key, required this.selectedItems, required this.change});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

bool _isFinished = false;


String getFormattedDateTime() {
  final now = DateTime.now();
  final dateFormat = DateFormat('dd/MM/yyyy '); // For xx/xx/xxxx format
  final timeFormat = DateFormat('HH:mm \n'); // For xx:xx format

  final formattedDate = dateFormat.format(now);
  final formattedTime = timeFormat.format(now);

  return '$formattedDate \n                 $formattedTime';
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  double total = 0.0;
  
  final screenshotController = ScreenshotController(); 
  void calculateTotalPrice() {
    total = 0.0; // Reset total before recalculating

    for (var item in widget.selectedItems) {
      total += item["price"] * item["count"];
    }
  }


  String generateReceiptText() {
    String receiptText =
        "            ${getFormattedDateTime()}--------------------------------\n                  Order #\nQty.             Item.           Price\n";

    for (var item in widget.selectedItems) {
      receiptText +=
          "\n${item["count"]}       ${item["name"]} ------------- ${item["price"]}\n";
    }
    receiptText +="\n######################\nTotal: \$${total.toStringAsFixed(2)}\n";
    if (widget.change >= 0) {
      receiptText += "Change: \$${widget.change.toStringAsFixed(2)}\n";
    }
    
    return receiptText;
  }
  



  // New function to capture and share screenshot
  Future<void> takeScreenshot() async {
    final image = await screenshotController.captureFromWidget(Center(
      child: Container(
        color: Colors.white,
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Omar\'s Eatery, Inc.',
              style: GoogleFonts.lato(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                generateReceiptText(),
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ));

    
  // ignore: unnecessary_null_comparison
  if (image != null) {
    final temporaryDirectory = await getTemporaryDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = '${temporaryDirectory.path}/$fileName.png';
    await File(path).writeAsBytes(image);
    // Wrap the path in a list and use Share.shareFiles
    await Share.shareXFiles([XFile(path)]);
  }
  setState(() {
    _isFinished = true;
  });

  Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => HomeApp(
                isFinished: _isFinished,
              ),
            ),
          );
  }
  


  @override
  Widget build(BuildContext context) {
    calculateTotalPrice();
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
      body: Screenshot(
        controller: screenshotController,
        child: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 100)), // Short delay
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Container(
                  width: 400,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Omar\'s Eatery, Inc.',
                        style: GoogleFonts.lato(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          generateReceiptText(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      ElevatedButton(
                        onPressed: takeScreenshot,
                        child: const Text('Screenshot Receipt'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
