import 'package:flutter/material.dart';
import '../img/list.dart';

void main() {
  runApp(const MenuScreen());
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index]; // Access each item in the list
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
                      // Replace FlutterLogo with image from list.dart
                      Image.network(
                        item[
                            "imageUrl"], // Access imageUrl property dynamically
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
                            // Replace Text widgets with Text from list.dart
                            Text(
                              item["text"], // Access text property dynamically
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              "Add",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.navigate_next, size: 25),
                    ],
                  ),
                ),
              );
            },
          ),
        )),
      ),
    );
  }
}
