import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderProvider extends ChangeNotifier {
  int orderCount = 0;
  String orderNumber = '';

  void incrementOrderCount() {
    orderCount++;
    generateOrderNumber();
    notifyListeners();
  }

  void generateOrderNumber() {
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String formattedDate = formatter.format(DateTime.now());
    orderNumber = '$formattedDate${orderCount.toString().padLeft(2, '0')}';
  }
}
