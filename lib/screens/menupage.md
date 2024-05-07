import 'package:flutter/material.dart';

import '../img/list.dart';

void main() {
  runApp(const MenuScreen());
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List _data = data; // Copy data to state
  int counter = 0;

  get math => null;

  get price => null;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(//1st category
                height: screenHeight * 0.45,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text "Categories" with emphasis
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text(
                        "Category 1",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // const SizedBox(width: 16.0),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          final item = _data[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                15.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    //image
                                    height: 60,
                                    width: 60,
                                    color: Colors.transparent,
                                    child: Image.network(
                                      item["imageUrl"],
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  Column(
                                    //menu name
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                       
                                        child: Center(
                                          child: Text(
                                            item["text"],
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        //price
                                      
                                        child: Center(
                                          child: Text(
                                            item != null &&
                                                    item.containsKey("price")
                                                ? "\$${item["price"]}"
                                                : "No Price", // Default to "No Price"
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                            ), // Optional: style the price text
                                          ),
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
                                      const SizedBox(width: 15.0),
                                      Row(
                                        //number
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0), // Add border radius
                                                color: Colors.red,
                                              ),
                                              width: 40,
                                              height: 40,
                                              child: IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () => setState(() {
                                                  if (_data[index]
                                                      .containsKey("count")) {
                                                    final count = _data[index]
                                                            ["count"] ??
                                                        0; // Handle null case with default 0
                                                    if (count > 0) {
                                                      _data[index]["count"] =
                                                          count - 1;
                                                    }
                                                  }
                                                }),
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
                                            padding: const EdgeInsets.all(10.0),
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
                                                onPressed: () => setState(() {
                                                  if (_data[index].containsKey(
                                                          "count") &&
                                                      _data[index]
                                                          .containsKey("max")) {
                                                    final count = _data[index]
                                                            ["count"] ??
                                                        0; // Handle null case with default 0
                                                    if (count <
                                                        _data[index]["max"]) {
                                                      _data[index]["count"] =
                                                          count + 1;
                                                    }
                                                  }
                                                }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container( //2nd category
                height: screenHeight * 0.45,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text "Categories" with emphasis
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text(
                        "Category 1",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // const SizedBox(width: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          final item = _data[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                15.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    //image
                                    height: 60,
                                    width: 60,
                                    color: Colors.transparent,
                                    child: Image.network(
                                      item["imageUrl"],
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  Column(
                                    //menu name
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                       
                                        child: Center(
                                          child: Text(
                                            item["text"],
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        //price
                                      
                                        child: Center(
                                          child: Text(
                                            item != null &&
                                                    item.containsKey("price")
                                                ? "\$${item["price"]}"
                                                : "No Price", // Default to "No Price"
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                            ), // Optional: style the price text
                                          ),
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
                                      const SizedBox(width: 15.0),
                                      Row(
                                        //number
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0), // Add border radius
                                                color: Colors.red,
                                              ),
                                              width: 40,
                                              height: 40,
                                              child: IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () => setState(() {
                                                  if (_data[index]
                                                      .containsKey("count")) {
                                                    final count = _data[index]
                                                            ["count"] ??
                                                        0; // Handle null case with default 0
                                                    if (count > 0) {
                                                      _data[index]["count"] =
                                                          count - 1;
                                                    }
                                                  }
                                                }),
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
                                            padding: const EdgeInsets.all(10.0),
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
                                                onPressed: () => setState(() {
                                                  if (_data[index].containsKey(
                                                          "count") &&
                                                      _data[index]
                                                          .containsKey("max")) {
                                                    final count = _data[index]
                                                            ["count"] ??
                                                        0; // Handle null case with default 0
                                                    if (count <
                                                        _data[index]["max"]) {
                                                      _data[index]["count"] =
                                                          count + 1;
                                                    }
                                                  }
                                                }),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
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
      ),
    );
  }
}
