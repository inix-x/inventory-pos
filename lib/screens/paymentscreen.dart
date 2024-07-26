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
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextField(
              controller: _textFieldController,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.right,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(
                    r'^\d*\.?\d{0,2}$')), // Allow digits and up to two decimal places
                LengthLimitingTextInputFormatter(5), // Limit to 5 digits
              ],
              obscureText: false,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: Theme.of(context).textTheme.displayMedium,
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _textFieldController.text = '0';
                    _textFieldController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _textFieldController.text.length),
                    );
                  } else if (RegExp(r'^0{2,}$').hasMatch(value)) {
                    _textFieldController.text = '0';
                    _textFieldController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _textFieldController.text.length),
                    );
                  } else if (RegExp(r'^\.{2,}$').hasMatch(value)) {
                    _textFieldController.text = '.';
                    _textFieldController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _textFieldController.text.length),
                    );
                  } else {
                    cashAmount = double.tryParse(value);
                  }
                });
              },
            ),
          ),

// Number pad
          // Number pad
Expanded(
  child: GridView.count(
    crossAxisCount: 3,
    childAspectRatio: 1.2,
    mainAxisSpacing: 5,
    crossAxisSpacing: 5,
    padding: const EdgeInsets.all(5),
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '7';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '7',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '8';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '8',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '9';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '9',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '4';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '4',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '5';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '5',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '6';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '6',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '1';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '1',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '2';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '2',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5) {
              _textFieldController.text += '3';
              cashAmount = double.tryParse(_textFieldController.text);
            }
          });
        },
        child: Text(
          '3',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5 &&
                !_textFieldController.text.contains('.')) {
              _textFieldController.text += '.';
              cashAmount = double.tryParse(_textFieldController.text);
            }
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
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            if (_textFieldController.text.length < 5 &&
                _textFieldController.text != '0') {
              _textFieldController.text += '0';
              cashAmount = double.tryParse(_textFieldController.text);
            }
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
            borderRadius: BorderRadius.circular(0),
          ),
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
