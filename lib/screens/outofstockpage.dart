import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/themes/settings.dart';
import 'package:flutter_application_1/themes/theme_color.dart';

class OutOfStockPage extends StatefulWidget {
  const OutOfStockPage({super.key,});

  @override
  State<OutOfStockPage> createState() => _OutOfStockPageState();
}

class _OutOfStockPageState extends State<OutOfStockPage> {
  List<SelectedItems> outOfStockList = [];

  @override
  void initState() {
    super.initState();
    _fetchOutOfStockItems();
  }

  void _fetchOutOfStockItems() async {
    final dbService = DatabaseService.instance;
    final items = await dbService.fetchOutOfStockSelectedItems();
    setState(() {
      outOfStockList = items;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Text('Out of Stock',
                style: Theme.of(context).textTheme.displayMedium),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: outOfStockList.length,
                itemBuilder: (context, index) {
                  final item = outOfStockList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: ThemeColors.lightCardColor,
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('Count: ${item.count}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: const Alignment(1.1, 0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              onPressed: () {},
              color: Colors.green,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.refresh_outlined, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: () {},
              color: Colors.blue,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.print_outlined, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
