import 'dart:async';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/global/common/toast.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart'
    as category_provider;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/loginwidget/auth_service.dart';

// Import the CartScreen
import 'package:flutter_application_1/screens/cartscreen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.isFinished});
  final bool isFinished;

  @override
  // ignore: library_private_types_in_public_api
  _MenuScreenState createState() => _MenuScreenState();
}

class SelectedItem {
  final String name;
  final double price;
  int count;

  SelectedItem({required this.name, required this.price, required this.count});

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'count': count,
      };
}

class _MenuScreenState extends State<MenuScreen> with WidgetsBindingObserver {
  Map<int, List<Item>> placeholderItemsMap = {};
  int? selectedCategoryId;
  late ScrollController _scrollController;
  final TextEditingController _searchController =
      TextEditingController(); // Initialize _searchController here
  Timer? _debounce;
  List<Item> _searchResults = [];
  List<SelectedItem> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController
        .addListener(_onSearchChanged); // Add listener after initialization
    WidgetsBinding.instance.addObserver(this); // Add observer
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose(); // Dispose of _searchController properly
    _debounce?.cancel();
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  // Implementing the observer method
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      AuthService().signout(); // Sign out user
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (_searchController.text.isNotEmpty) {
        _lazySearch(_searchController.text);
      } else {
        setState(() {
          _searchResults.clear();
        });
      }
    });
  }

  Future<void> _lazySearch(String query) async {
    final categoryProvider = context.read<category_provider.CategoryProvider>();
    final items = await categoryProvider.fetchItemsByName(query);

    setState(() {
      _searchResults = items;
    });
  }

  void _incrementItemCount(Item item) {
    setState(() {
      final selectedItem = selectedItems.firstWhere(
        (selectedItem) => selectedItem.name == item.name,
        orElse: () =>
            SelectedItem(name: item.name, price: item.price, count: 0),
      );

      if (selectedItem.count == 0) {
        selectedItems.add(selectedItem);
      }

      selectedItem.count += 1;

      if (kDebugMode) {
        print(selectedItems.map((item) => item.toMap()).toList());
      }
    });
  }

  void _decrementItemCount(Item item) {
    setState(() {
      final selectedItem = selectedItems.firstWhere(
        (selectedItem) => selectedItem.name == item.name,
        orElse: () =>
            SelectedItem(name: item.name, price: item.price, count: 0),
      );

      if (selectedItem.count > 0) {
        selectedItem.count -= 1;

        if (selectedItem.count == 0) {
          selectedItems.removeWhere((element) => element.name == item.name);
        }
      }

      if (kDebugMode) {
        print(selectedItems.map((item) => item.toMap()).toList());
      }
    });
  }

  int _getTotalItemCount() {
    return selectedItems.fold(0, (total, item) => total + item.count);
  }

  double _getTotalPrice() {
    return selectedItems.fold(
        0.0, (total, item) => total + (item.price * item.count));
  }

  void _navigateToCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(selectedItems: selectedItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.read<category_provider.CategoryProvider>();
    Future<List<category_provider.Category>> categoryList =
        categoryProvider.fetchCategory();

    return Scaffold(
      body: FutureBuilder<List<category_provider.Category>>(
        future: categoryList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories available'));
          } else {
            if (selectedCategoryId == null &&
                snapshot.hasData &&
                snapshot.data!.isNotEmpty) {
              selectedCategoryId = snapshot.data!.first.id;
            }

            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for items',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (_searchResults.isNotEmpty)
                  Expanded(
                    child: ListView(
                      children: _searchResults.map((item) {
                        return Card(
                          child: ListTile(
                            title: Text(item.name),
                            subtitle:
                                Text('\$${item.price.toStringAsFixed(2)}'),
                            leading: item.imagePath.isNotEmpty
                                ? Image.network(item.imagePath)
                                : null,
                            onTap: () {
                              setState(() {
                                selectedCategoryId = item.id;
                                _searchController.clear();
                                _searchResults.clear();
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  )
                else if (selectedCategoryId != null)
                  Expanded(
                    // Changed to Expanded to fill remaining space
                    child: FutureBuilder<List<Item>>(
                      future: categoryProvider
                          .fetchItemByCategoryId(selectedCategoryId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No items available'));
                        } else {
                          return ListView(
                            children: snapshot.data!.map((item) {
                              final selectedItem = selectedItems.firstWhere(
                                (selectedItem) =>
                                    selectedItem.name == item.name,
                                orElse: () => SelectedItem(
                                    name: item.name,
                                    price: item.price,
                                    count: 0),
                              );

                              return Card(
                                child: ListTile(
                                  title: Text(item.name),
                                  subtitle: Text(
                                      '\$${item.price.toStringAsFixed(2)}'),
                                  leading: item.imagePath.isNotEmpty
                                      ? Image.network(item.imagePath)
                                      : null,
                                  trailing: SizedBox(
                                    // Wrapping Row in SizedBox
                                    width: 120,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () =>
                                              _decrementItemCount(item),
                                        ),
                                        Text('${selectedItem.count}'),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () =>
                                              _incrementItemCount(item),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  key: const PageStorageKey('categoryRowScrollPosition'),
                  child: Row(
                    children: snapshot.data!.map((category) {
                      return Container(
                        width: 100, // Fixed width for each container
                        height: 50, // Fixed height for each container
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                          color: selectedCategoryId == category.id
                              ? Colors.blueAccent
                              : Colors.transparent,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategoryId = category.id;
                            });
                            if (kDebugMode) {
                              print(
                                  'Selected Category ID: $selectedCategoryId');
                            }
                          },
                          child: Center(
                            child: Text(
                              category.name,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Items: ${_getTotalItemCount()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    ' Total price: \$${_getTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const DottedLine(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                dashLength: 5,
                lineLength: double.infinity,
                lineThickness: 1.0,
                dashColor: primaryColor,
              ),
             
              Flexible(
                child: MaterialButton(
                  onPressed: (){
                    if(selectedItems.isEmpty){
                      showToast(message: 'No items to checkout');
                    }else{
                       _navigateToCartScreen();
                    }
                   
                  },
                  child: Text(
                    'Checkout',
                    style: GoogleFonts.quattrocento(
                      textStyle: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
