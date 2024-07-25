import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/providers/ordernumberprovider.dart';
import 'package:flutter_application_1/screens/receiptscreen.dart';
import 'package:flutter_application_1/themes/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // For formatting date

class PaymentScreen extends StatefulWidget {
  final List<SelectedItems> selectedItems;
  const PaymentScreen({super.key, required this.selectedItems});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final player = AudioPlayer();
  double total = 0.0;
  double? cashAmount; // Variable to store cash input

  int orderCount = 1; // This will be auto-incremented
  String orderNumber = '';
  DateTime? lastOrderDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.incrementOrderCount();
    });
  }

  void generateOrderNumber() {
    DateTime now = DateTime.now();
    if (lastOrderDate == null || !isSameDay(lastOrderDate!, now)) {
      lastOrderDate = now;
      orderCount = 1; // Reset order count for the new day
    } else {
      orderCount++; // Increment order count for the same day
    }
    String formattedDate =
        DateFormat('MMddyyyy').format(now); // Format: MMddyyyy
    orderNumber = '$formattedDate${orderCount.toString().padLeft(2, '0')}';
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void calculateTotalPrice() {
    total = 0.0; // Reset total before recalculating

    for (var item in widget.selectedItems) {
      total += item.price * item.max;
    }
  }

  double calculateChange() {
    if (cashAmount != null) {
      return cashAmount! - total;
    } else {
      return 0.0; // Handle case where no cash amount is entered
    }
  }

  void handleCashPayment() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Update item counts in the database
    DatabaseService.instance.updateItemCount(widget.selectedItems);

    double change = calculateChange();
    if (change >= 0 && cashAmount != null) {
      player.play(AssetSource('sounds/cash-register.mp3'));
      // Show success message and change amount (if any)
      if (kDebugMode) {
        print('Payment successful! Change: \$${change.toStringAsFixed(2)}');
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(
            selectedItems: widget.selectedItems,
            change: change,
            orderNumber: orderProvider.orderNumber, // Pass the orderNumber here
          ),
        ),
      );
    } else {
      // Show error message for insufficient cash
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Insufficient Cash! '),
          content: const Text('Please enter a higher amount than the total.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (kDebugMode) {
        print('Insufficient cash! Please enter a higher amount.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalPrice(); // Calculate the total price of the selectedItems.
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
            Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                return Text('Order #${orderProvider.orderNumber}',
                    style: Theme.of(context).textTheme.displaySmall);
              },
            ),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Your Total is: \$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displayMedium),
              SizedBox(
                width: 300,
                child: TextField(
                  style: Theme.of(context).textTheme.displaySmall,
                  keyboardType:
                      TextInputType.number, // Display numeric keyboard
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allow only digits 0-9
                    MaxValueInputFormatter(
                        maxValue: 100000), // Limit maximum value to 10000
                  ],
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Payment Amount',
                    labelStyle: Theme.of(context).textTheme.displaySmall,
                  ),
                  onChanged: (value) {
                    cashAmount = double.tryParse(
                        value); // Update cashAmount on input change
                  },
                ),
              ),
              Container(
                height: 100,
                width: 250,
                color: Colors.green,
                child: MaterialButton(
                  onPressed: handleCashPayment,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('PAY',
                          style: Theme.of(context).textTheme.displayMedium),
                      Icon(
                        Icons.payment_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
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

class MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  MaxValueInputFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Prevent input starting with "0"
    if (newValue.text.startsWith('0') && newValue.text.length > 1) {
      return oldValue;
    }

    // Limit to max value
    final intValue = int.tryParse(newValue.text);
    if (intValue != null && intValue <= maxValue) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
