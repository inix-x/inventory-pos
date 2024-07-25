import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/screens/homepage.dart';
import 'package:flutter_application_1/themes/settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class ReceiptScreen extends StatefulWidget {
  final List<SelectedItems> selectedItems;
  final double change;
  final String orderNumber; // Add orderNumber parameter
  final screenshotController =
      ScreenshotController(); // New variable for screenshot

  ReceiptScreen({super.key, required this.selectedItems, required this.change, required this.orderNumber});

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
      total += item.price * item.count;
    }
  }

  String generateReceiptText() {
    String receiptText =
        "            ${getFormattedDateTime()}--------------------------------\n       Order #${widget.orderNumber}\nQty.             Item.           Price\n";

    for (var item in widget.selectedItems) {
      receiptText +=
          "\n${item.count}       ${item.name} ------------- ${item.price}\n";
    }
    receiptText +=
        "\n######################\nTotal: \$${total.toStringAsFixed(2)}\n";
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
              'Business Inc.',
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: (){},
        ),
        title: Row(children: [
          const Spacer(),
          Text('Receipt', style: Theme.of(context).textTheme.displayMedium),
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
        ]),
      ),
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: FutureBuilder(
                future: Future.delayed(
                    const Duration(milliseconds: 100)), // Short delay
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Container(
                        width: 400,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Business Name, Inc.',
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                generateReceiptText(),
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.displaySmall,
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
          ),
          // Container for the ad
          Container(
            // margin: const EdgeInsets.all(10),
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                "ADS HERE",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
