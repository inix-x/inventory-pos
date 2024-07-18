import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/global/common/toast.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart'
    as category_provider;
import 'package:flutter_application_1/providers/themeprovider.dart';
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
  final ValueNotifier<int?> selectedCategoryId = ValueNotifier<int?>(null);
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Item> _searchResults = [];
  List<SelectedItem> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Implementing the observer method
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      AuthService().signout();
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

      // Ensure selectedItem.count does not exceed item.count
      if (selectedItem.count < item.count) {
        selectedItem.count += 1;
      } else {
        showToast(message: 'Cannot add more items. Stock limit reached.');
      }

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
  if (selectedItems.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(selectedItems: selectedItems),
      ),
    );
  } else {
    showToast(message: 'No items to checkout');
  }
}


  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context, listen: false);
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
            if (selectedCategoryId.value == null &&
                snapshot.hasData &&
                snapshot.data!.isNotEmpty) {
              selectedCategoryId.value = snapshot.data!.first.id;
            }

            return Column(
              children: [
                // Search Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextField(
                    style: Theme.of(context).textTheme.displaySmall,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for items',
                      hintStyle: Theme.of(context).textTheme.displaySmall,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).iconTheme.color,
                      ),
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
                              selectedCategoryId.value = item.id;
                              _searchController.clear();
                              _searchResults.clear();
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  )
                else
                  Expanded(
                    child: ValueListenableBuilder<int?>(
                      valueListenable: selectedCategoryId,
                      builder: (context, selectedCategoryIdValue, child) {
                        if (selectedCategoryIdValue == null) {
                          return const Center(
                              child: Text('No items available'));
                        }

                        return FutureBuilder<List<Item>>(
                          future: categoryProvider
                              .fetchItemByCategoryId(selectedCategoryIdValue),
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

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 3),
                                    child: Card(
                                      color: Theme.of(context).cardColor,
                                      child: ListTile(
                                        title: Text(
                                          item.name,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '\$${item.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                        leading: item.imagePath.isNotEmpty
                                            ? Image.network(item.imagePath)
                                            : null,
                                        trailing: SizedBox(
                                          width: 120,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.remove,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                                onPressed: () {
                                                  _decrementItemCount(item);
                                                },
                                              ),
                                              Text(
                                                '${selectedItem.count}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                ),
                                                onPressed: () {
                                                  _incrementItemCount(item);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                CategoryScrollView(
                  categoryList: snapshot.data!,
                  selectedCategoryId: selectedCategoryId,
                  scrollController: _scrollController,
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Items: ${_getTotalItemCount()}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              ' Total price: \$${_getTotalPrice().toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: const Alignment(1, 0.85),
        child: CheckoutButton(
          selectedItems: selectedItems,
          onPressed: () {
            if (selectedItems.isEmpty) {
              showToast(message: 'No items to checkout');
            } else {
              _navigateToCartScreen();
            }
          },
        ),
      ),
    );
  }
}

class CategoryScrollView extends StatelessWidget {
  final List<category_provider.Category> categoryList;
  final ValueNotifier<int?> selectedCategoryId;
  final ScrollController scrollController;

  const CategoryScrollView({
    super.key,
    required this.categoryList,
    required this.selectedCategoryId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      key: const PageStorageKey('categoryRowScrollPosition'),
      child: Row(
        children: categoryList.map((category) {
          return ValueListenableBuilder<int?>(
            valueListenable: selectedCategoryId,
            builder: (context, selectedCategoryIdValue, child) {
              return Container(
                width: 100,
                height: 50,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                  color: selectedCategoryIdValue == category.id
                      ? Colors.blueAccent
                      : Theme.of(context).cardColor,
                ),
                child: GestureDetector(
                  onTap: () {
                    selectedCategoryId.value = category.id;
                    if (kDebugMode) {
                      print('Selected Category ID: $selectedCategoryId');
                    }
                  },
                  child: Center(
                    child: Text(
                      category.name,
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final List<SelectedItem> selectedItems;
  final VoidCallback onPressed;

  const CheckoutButton({
    super.key,
    required this.selectedItems,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.greenAccent,
      child:  const Icon(Icons.shopping_cart_checkout , color: Colors.white),
    );
  }
}
