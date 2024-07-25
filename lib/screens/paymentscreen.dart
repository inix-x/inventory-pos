import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/providers/ordernumberprovider.dart';
import 'package:flutter_application_1/screens/receiptscreen.dart';
import 'package:flutter_application_1/themes/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final List<SelectedItems> selectedItems;
  const PaymentScreen({super.key, required this.selectedItems});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final player = AudioPlayer();
  final TextEditingController _textFieldController =
      TextEditingController(); // Add this line
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
                    style: Theme.of(context).textTheme.headlineMedium);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: _textFieldController, // Add a controller
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.right, // Align text to the right
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true), // Display numeric keyboard with decimal
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9.]')), // Allow digits and decimal point
                MaxValueInputFormatter(
                    maxValue: 100000), // Limit maximum value to 10000
              ],
              obscureText: false,
              decoration:  InputDecoration(
                hintText: '0', // Set default hint text to "0"
                hintStyle: Theme.of(context).textTheme.displayMedium,
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _textFieldController.text =
                        '0'; // Set default value to "0" if input is empty
                    _textFieldController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _textFieldController.text.length),
                    );
                  } else if (RegExp(r'^0+$').hasMatch(value)) {
                    _textFieldController.text =
                        '0'; // Restrict input to a single "0" if a series of zeroes is detected
                    _textFieldController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _textFieldController.text.length),
                    );
                  } else {
                    cashAmount = double.tryParse(
                        value); // Update cashAmount on input change
                  }
                });
              },
            ),
          ),

          const SizedBox(
              height:
                  10), // Add some spacing between the TextField and number pad
          // Number pad
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(10),
              children: [
                ...List.generate(9, (index) {
                  int number = index + 1;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      setState(() {
                        // Update the TextField value
                        _textFieldController.text += number.toString();
                        cashAmount = double.tryParse(_textFieldController.text);
                      });
                    },
                    child: Text(
                      '$number',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  );
                }),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      _textFieldController.text += '.';
                      cashAmount = double.tryParse(_textFieldController.text);
                    });
                  },
                  child: Text(
                    '.',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      _textFieldController.text += '0';
                      cashAmount = double.tryParse(_textFieldController.text);
                    });
                  },
                  child: Text(
                    '0',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_textFieldController.text.isNotEmpty) {
                        _textFieldController.text = _textFieldController.text
                            .substring(0, _textFieldController.text.length - 1);
                        cashAmount = double.tryParse(_textFieldController.text);
                      }
                    });
                  },
                  child: Icon(
                    Icons.backspace,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SizedBox(
          height: 60.0,
          child: ElevatedButton(
            onPressed: handleCashPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PAY',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(width: 8.0),
                const Icon(
                  Icons.payment_outlined,
                  color: Colors.white,
                ),
              ],
            ),
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
