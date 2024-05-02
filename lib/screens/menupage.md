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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
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
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item["text"],
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => setState(() {
                                      // Decrement only if count is greater than 0
                                      _data[index]["count"] =
                                          math.max(0, _data[index]["count"]);
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
                                    onPressed: () => setState(() => _data[index]
                                            ["count"] =
                                        (_data[index]["count"] ?? 0) + 1),
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
          ),
        ),
      ),
    );
  }
}
