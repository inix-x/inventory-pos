import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cartscreen.dart';
import 'package:dotted_line/dotted_line.dart';

import '../img/list.dart';
import '../img//list1.dart';

void main() async {
  runApp(const MenuScreen());
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // ignore: prefer_final_fields
  List _data = data;
  // ignore: prefer_final_fields
  List _data1 = data1;
// Copy data to state

  final List<Map<String, dynamic>> selectedItems = [];

  //counter  shows the number of items added to the cart widget in the floating action button
  int counter = 0;

  double totalPrice =
      0.0; //totalPrice of the Cart added items in selectedItems List

  //This Boolean section toggles the visibility of the counter of each card item and enables each category container to expand based on t or f.
  bool _showCounter = false;
  bool _showCounter1 = false;

  //debugging function to ensure that there's an element inside an array or List.
  void logListContent() {
    //unused printing for every element in a list
    for (var item in selectedItems) {
      if (kDebugMode) {
        print(item); //displays each element in the data from list.dart
      }
    }
  }

double calculateTotalPrice() {
  double total = 0.0;
  for (var item in selectedItems) {
    // Check if item has "count" key (assuming it might not always exist)
    if (item.containsKey("count")) {
      int count = item["count"];
      total += item["price"] * count;  // Multiply price by count
    } else {
      // Handle case where "count" is missing (optional)
      if (kDebugMode) {
        print('Item in selectedItems missing "count" key.');
      }
    }
  }
  return total;
}

void removeFromSelectedItems(int index) {
  // Check if index is within bounds
  if (index < 0 || index >= selectedItems.length) {
    if (kDebugMode) {
      print('Warning: Index out of bounds for selectedItems.');
    }
    return;
  }

  // Get the item and its count (assuming "count" exists)
  Map<String, dynamic> item = selectedItems[index];
  int count = item.containsKey("count") ? item["count"] : 1;

  // Handle removing single item or decrementing count
  if (count == 1) {
    // Remove the item from selectedItems
    selectedItems.removeAt(index);
  } else {
    // Decrement count
    count--;
    item["count"] = count;
  }

  // Update total price based on selectedItems
  totalPrice = calculateTotalPrice(); // Call the calculateTotalPrice function
}


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //Scaffold contains the UI of a mobile device as a whole
        body: SingleChildScrollView(
          //Widget that enables Scrollablity of the widgets.
          child: Column(
            //displays the contents in a column or vertical manner
            children: [
              Container(
                //1st category container
                decoration: const BoxDecoration(
                  color: Color.fromARGB(244, 244, 244, 244),
                ),
                height: _showCounter
                    ? screenHeight * 0.55
                    : screenHeight *
                        0.45, //The height changes depending on the _showCounter for the display to be responsive and flexible
                padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text "Categories" with emphasis
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0, bottom: 10),
                      child: Text(
                        "Category 1",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        dashLength: 5,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashColor: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          final item = _data[index];
                          return GestureDetector(
                            onTap: () => setState(() {
                              _showCounter = !_showCounter;
                              if (kDebugMode) {
                                print(
                                    "$_showCounter"); //displays each element in the data from list.dart
                              }
                            }),
                            child: Card(
                              margin: const EdgeInsets.only(
                                  top: 3, left: 8, right: 8, bottom: 12),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      //image
                                      height: 40,
                                      width: 40,
                                      color: Colors.transparent,
                                      child: Image.network(
                                        item["imageUrl"],
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    Column(
                                      //menu name
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            item["text"],
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            item != null &&
                                                    item.containsKey("price")
                                                ? "\$${item["price"]}"
                                                : "No Price", // Default to "No Price"
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                            ), // Optional: style the price text
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      //text
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,

                                      children: [
                                        const SizedBox(width: 12.0),
                                        Visibility(
                                          visible: _showCounter,
                                          child: Row(
                                            //number
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Add border radius
                                                    color: Colors.red,
                                                  ),
                                                  width: 40,
                                                  height: 40,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      onPressed: () =>
                                                          setState(() {
                                                        int count = _data[index]
                                                            ["count"];
                                                        if (_data[index]
                                                            .containsKey(
                                                                "count")) {
                                                          // Check if selectedItems is not empty and the item exists in selectedItems

                                                          if (selectedItems
                                                                  .isNotEmpty &&
                                                              selectedItems.any((item) =>
                                                                  item[
                                                                      "text"] ==
                                                                  _data[index][
                                                                      "text"])
                                                                      ) {
                                                            // Find the index of the item based on "text" (assuming this approach)
                                                            int indexToRemove =
                                                                selectedItems.indexWhere((item) =>
                                                                    item[
                                                                        "text"] ==
                                                                    _data[index]
                                                                        [
                                                                        "text"]);

                                                            // Remove the item and update total price
                                                            removeFromSelectedItems(
                                                                indexToRemove);

                                                            // Decrement count if it's greater than 0
                                                            if (count > 0) {
                                                              count--;
                                                              _data[index][
                                                                      "count"] =
                                                                  count;
                                                              counter--;
                                                            }
                                                          } else {
                                                            if (kDebugMode) {
                                                              print(
                                                                  'Item not found in selected items or selectedItems is empty.');
                                                            }
                                                          }
                                                        }
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                (_data[index]["count"] ?? 0)
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Add border radius
                                                    color: Colors.green,
                                                  ),
                                                  width: 40,
                                                  height: 40,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.add),
                                                    onPressed: () =>
                                                        setState(() {
                                                      int count =
                                                          _data[index]["count"];
                                                      if (_data[index]
                                                          .containsKey("max")) {
                                                        if (count <
                                                            _data[index]
                                                                ["max"]) {
                                                          count++;
                                                          _data[index]
                                                              ["count"] = count;
                                                          counter++;
                                                        }
                                                      }
                                                      if (kDebugMode) {
                                                        print(
                                                            'the count is $count and the counter is $counter');
                                                      }

                                                      // Check if item exists in selectedItems before adding
                                                      bool foundExistingItem =
                                                          false;
                                                      for (var item
                                                          in selectedItems) {
                                                        if (item["id"] ==
                                                                _data[index]
                                                                    ["id"] &&
                                                            item["id"] !=
                                                                null) {
                                                          // Check for null id
                                                          foundExistingItem =
                                                              true;
                                                          item[
                                                              "count"]++; // Increment count of existing item
                                                          break;
                                                        }
                                                      }

                                                      if (!foundExistingItem &&
                                                          count > 0) {
                                                        selectedItems.add({
                                                          "text": _data[index]
                                                              ["text"],
                                                          "price": _data[index]
                                                              ["price"],
                                                          "count": count,
                                                          "id": _data[index][
                                                              "id"], // Assuming data has an "id" key
                                                        });
                                                      }
                                                      totalPrice =
                                                          calculateTotalPrice();
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                //2nd category
                height:
                    _showCounter1 ? screenHeight * 0.60 : screenHeight * 0.5,
                padding: const EdgeInsets.only(top: 5, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text "Categories" with emphasis
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0, bottom: 10),
                      child: Text(
                        "Category 2",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        dashLength: 5,
                        lineLength: double.infinity,
                        lineThickness: 1.0,
                        dashColor: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _data1.length,
                        itemBuilder: (context, index) {
                          final item = _data1[index];
                          return GestureDetector(
                            onTap: () => setState(() {
                              _showCounter1 = !_showCounter1;
                              if (kDebugMode) {
                                print(
                                    "$_showCounter1"); //displays each element in the data from list.dart
                              }
                            }),
                            child: Card(
                              margin: const EdgeInsets.only(
                                  top: 3, left: 8, right: 8, bottom: 12),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      //image
                                      height: 40,
                                      width: 40,
                                      color: Colors.transparent,
                                      child: Image.network(
                                        item["imageUrl"],
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    Column(
                                      //menu name
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            item["text"],
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            item != null &&
                                                    item.containsKey("price")
                                                ? "\$${item["price"]}"
                                                : "No Price", // Default to "No Price"
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                            ), // Optional: style the price text
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      //text
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,

                                      children: [
                                        const SizedBox(width: 12.0),
                                        Visibility(
                                          visible: _showCounter1,
                                          child: Row(
                                            //number
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Add border radius
                                                    color: Colors.red,
                                                  ),
                                                  width: 40,
                                                  height: 40,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      onPressed: () =>
                                                          setState(() {
                                                        int count1 =
                                                            _data1[index]
                                                                ["count"];
                                                        if (_data1[index]
                                                            .containsKey(
                                                                "count")) {
                                                          // Check if selectedItems is not empty and the item exists in selectedItems
                                                          if (selectedItems
                                                                  .isNotEmpty &&
                                                              selectedItems.any((item) =>
                                                                  item[
                                                                      "text"] ==
                                                                  _data1[index][
                                                                      "text"])) {
                                                            // Find the index of the item based on "text" (assuming this approach)
                                                            int indexToRemove =
                                                                selectedItems.indexWhere((item) =>
                                                                    item[
                                                                        "text"] ==
                                                                    _data1[index]
                                                                        [
                                                                        "text"]);

                                                            // Remove the item and update total price
                                                            removeFromSelectedItems(
                                                                indexToRemove);

                                                            // Decrement count if it's greater than 0
                                                            if (count1 > 0) {
                                                              count1--;
                                                              _data[index][
                                                                      "count"] =
                                                                  count1;
                                                              counter--;
                                                            }
                                                          } else {
                                                            if (kDebugMode) {
                                                              print(
                                                                  'Item not found in selected items or selectedItems is empty.');
                                                            }
                                                          }
                                                        }
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                (_data1[index]["count"] ?? 0)
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Add border radius
                                                    color: Colors.green,
                                                  ),
                                                  width: 40,
                                                  height: 40,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.add),
                                                    onPressed: () =>
                                                        setState(() {
                                                      int count1 =
                                                          _data1[index]["count"];
                                                      if (_data1[index]
                                                          .containsKey("max")) {
                                                        if (count1 <
                                                            _data1[index]
                                                                ["max"]) {
                                                          count1++;
                                                          _data1[index]
                                                              ["count"] = count1;
                                                          counter++;
                                                        }
                                                      }
                                                      if (kDebugMode) {
                                                        print(
                                                            'the count is $count1 and the counter is $counter');
                                                      }

                                                      // Check if item exists in selectedItems before adding
                                                      bool foundExistingItem1 =
                                                          false;
                                                      for (var item
                                                          in selectedItems) {
                                                        if (item["id"] ==
                                                                _data1[index]
                                                                    ["id"] &&
                                                            item["id"] !=
                                                                null) {
                                                          // Check for null id
                                                          foundExistingItem1 =
                                                              true;
                                                          item[
                                                              "count"]++; // Increment count of existing item
                                                          break;
                                                        }
                                                      }

                                                      if (!foundExistingItem1 &&
                                                          count1 > 0) {
                                                        selectedItems.add({
                                                          "text": _data1[index]
                                                              ["text"],
                                                          "price": _data1[index]
                                                              ["price"],
                                                          "count": count1,
                                                          "id": _data1[index][
                                                              "id"], // Assuming data has an "id" key
                                                        });
                                                      }
                                                      totalPrice =
                                                          calculateTotalPrice();
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Theme(
          data: Theme.of(context).copyWith(
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              extendedSizeConstraints: BoxConstraints.tightFor(height: 60),
            ),
          ),
          child: FloatingActionButton.extended(
            icon: const Icon(Icons.shopping_basket),
            label: Text(
                'Your $counter Added Items   \$$totalPrice'), // Update label with counter and totalPrice
            onPressed: () {
              if (selectedItems.isNotEmpty) {
                if (kDebugMode) {
                  print(
                      '$selectedItems'); //displays each element in the data from list.dart
                }
                // Navigate to CartScreen with selected items
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                        selectedItems: selectedItems, totalPrice: totalPrice),
                  ),
                );
              } else {
                // Show alert dialog if cart is empty
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cart is Empty'),
                    content: const Text(
                        'Please add items to your cart before proceeding.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Close dialog
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },

            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
