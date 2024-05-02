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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text "Categories" with emphasis
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    return Card(
                      margin: const EdgeInsets.all(16),
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 10),
                        child: Row(
                          children: [
                            Image.network(
                              item["imageUrl"],
                              width: 48,
                              height: 48,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          item["text"],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ),
                                    ],
                                    
                                  ),
                                      Center(
                                        child: Text(
                                          item != null &&
                                                  item.containsKey("price")
                                              ? "\$${item["price"]}"
                                              : "No Price", // Default to "No Price"
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  color: Colors
                                                      .grey), // Optional: style the price text
                                        ),
                                      ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () => setState(() {
                                          if (_data[index]
                                              .containsKey("count")) {
                                            final count = _data[index]
                                                    ["count"] ??
                                                0; // Handle null case with default 0
                                            if (count > 0) {
                                              _data[index]["count"] = count - 1;
                                            }
                                          }
                                        }),
                                      ),
                                      Text(
                                        (_data[index]["count"] ?? 0).toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => setState(() {
                                          if (_data[index]
                                                  .containsKey("count") &&
                                              _data[index].containsKey("max")) {
                                            final count = _data[index]
                                                    ["count"] ??
                                                0; // Handle null case with default 0
                                            if (count < _data[index]["max"]) {
                                              _data[index]["count"] = count + 1;
                                            }
                                          }
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
