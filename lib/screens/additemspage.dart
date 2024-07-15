import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/database/database.service.dart';
import 'package:flutter_application_1/global/common/toast.dart';
import 'package:flutter_application_1/loginwidget/customersignout.dart';
import 'package:flutter_application_1/providers/categoryprovider.dart'
    as category_provider;
import 'package:flutter_application_1/providers/themeprovider.dart';
import 'package:flutter_application_1/themes/settings.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/themes/theme_color.dart';

class AddItemspage extends StatefulWidget {
  final int itemIndex;
  final List<Item> items;

  const AddItemspage({
    super.key,
    required this.itemIndex,
    required this.items,
  });

  @override
  State<AddItemspage> createState() => _AddItemspageState();
}

class _AddItemspageState extends State<AddItemspage>
    with WidgetsBindingObserver {
  bool isSaved = true;
  // ignore: prefer_final_fields
  bool _isSwitched = ThemeProvider().isDarkTheme;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _showAddItemDialog() async {
    final itemNameController = TextEditingController();
    final itemPriceController = TextEditingController();
    final itemCountController = TextEditingController();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkTheme = themeProvider.isDarkTheme;
    final categoryProvider = context.read<category_provider.CategoryProvider>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkTheme
              ? ThemeColors.darkAlertDialogColor
              : ThemeColors.lightAlertDialogColor,
          title: Text(
            'Add Item details',
            style: Theme.of(context).textTheme.displayMedium
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: _buildTextField(itemNameController, 'Enter item name',
                    TextInputType.name, isDarkTheme),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: _buildTextField(itemPriceController, 'Enter item price',
                    TextInputType.number, isDarkTheme, [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ]),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: _buildTextField(itemCountController, 'Enter item stock',
                    TextInputType.number, isDarkTheme, [
                  FilteringTextInputFormatter.digitsOnly,
                ]),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.green),
              ),
              onPressed: () async {
                final itemName = itemNameController.text.trim();
                final itemPriceText = itemPriceController.text.trim();
                final itemCountText = itemCountController.text.trim();
                await _saveItem(
                    categoryProvider, itemName, itemPriceText, itemCountText);
              },
              child: const Text(
                'Save Item',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveItem(category_provider.CategoryProvider categoryProvider,
      String itemName, String itemPriceText, String itemCountText) async {
    final validItemName = RegExp(r'^[a-zA-Z\s]+$');

    if (itemName.isEmpty) {
      showToast(message: 'Item name cannot be empty');
    } else if (!validItemName.hasMatch(itemName)) {
      showToast(message: 'Item name can only contain letters and spaces');
    } else if (itemPriceText.isEmpty) {
      showToast(message: 'Item price cannot be empty');
    } else if (itemCountText.isEmpty) {
      showToast(message: 'Item count cannot be empty');
    } else {
      try {
        final itemPrice = double.parse(itemPriceText);
        final itemStock = int.parse(itemCountText);

        if (itemPrice <= 0) {
          showToast(message: 'Item price must be greater than 0');
        } else if (itemStock <= 0) {
          showToast(message: 'Item count must be greater than 0');
        } else {
          final dbService = DatabaseService.instance;
          final itemExists = await dbService.itemExists(itemName);

          if (itemExists) {
            showToast(message: 'The item already exists');
          } else {
            final newItem = Item(
              name: itemName,
              price: itemPrice,
              imagePath: '',
              count: itemStock,
              max: 10,
            );

            categoryProvider.addItemToPlaceholder(widget.itemIndex, newItem);

            if (mounted) {
              setState(() {
                isSaved = false;
              });
            }
            showToast(message: 'Please save the items first.');

            if (mounted) {
              Navigator.pop(context);
            }
          }
        }
      } catch (e) {
        showToast(message: 'Invalid input for price or count');
      }
    }
  }

  void _saveItemsToDatabase() async {
    final categoryProvider = context.read<category_provider.CategoryProvider>();
    final category = categoryProvider.categories[widget.itemIndex];
    final dbService = DatabaseService.instance;

    final categoryId = await dbService.fetchCategoryIdByName(category.name);

    if (categoryId != -1) {
      final placeholderItems =
          categoryProvider.getPlaceholderItems(widget.itemIndex);

      for (var item in placeholderItems) {
        await dbService.addItems(categoryId, [item]);
      }

      if (kDebugMode) {
        print('--- Stored Data in Database ---');
        final storedCategories = await dbService.fetchCategories();
        for (var data in storedCategories) {
          print(data);
        }
        final storedItems = await dbService.fetchItems();
        for (var data in storedItems) {
          print(data);
        }
      }

      showToast(message: 'Items Successfully Saved');

      if (mounted) {
        setState(() {
          categoryProvider.categories[widget.itemIndex].items
              .addAll(placeholderItems);
          isSaved = true;
        });

        Navigator.pop(context);
      }
    } else {
      showToast(message: 'Category not found');
    }
  }

  void _removeItem(int index) {
    final categoryProvider = context.read<category_provider.CategoryProvider>();
    categoryProvider.removeItem(widget.itemIndex, index);
  }

  Future<bool> _onWillPop() async {
    if (!isSaved) {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                  'There are items that are not saved to the database'),
              content: const Text('Would you like to save your items?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    _saveItemsToDatabase();
                    setState(() {
                      isSaved = true;
                    });
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        context.watch<category_provider.CategoryProvider>();
    final category = categoryProvider.categories[widget.itemIndex];
    final placeholderItems =
        categoryProvider.getPlaceholderItems(widget.itemIndex);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var isDarkTheme = themeProvider.isDarkTheme;
    // ignore: unused_local_variable
    var isDarkSwitch = _isSwitched;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isSaved
                  ? Customsignout(
                      onPressed: () {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: isDarkTheme
                              ? ThemeColors.darkIconColor
                              : ThemeColors.lightIconColor),
                    )
                  : const SizedBox(width: 1),
              const Spacer(),
              Text(
                category.name,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2,
                    color: isDarkTheme
                        ? ThemeColors.darkIconColor
                        : ThemeColors.lightIconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              //setting icon
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: isDarkTheme
                      ? ThemeColors.darkIconColor
                      : ThemeColors.lightIconColor,
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
            children: [
              placeholderItems.isNotEmpty
                  ? Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: placeholderItems.length,
                        itemBuilder: (context, index) {
                          final item = placeholderItems[index];
                          return ItemCard(
                            item: item,
                            onDelete: () => _removeItem(index),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDarkTheme
                              ? ThemeColors.darkEmptyMessageContainerColor
                              : ThemeColors.lightEmptyMessageContainerColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Please add items for ${category.name}',
                            style: GoogleFonts.robotoSerif(
                              textStyle: TextStyle(
                                color: isDarkTheme
                                    ? ThemeColors.darkEmptyMessageColor
                                    : ThemeColors.lightEmptyMessageColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
             
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ActionButton(
              iconData: Icons.add,
              onPressed: _showAddItemDialog,
              isDarkTheme: isDarkTheme,
            ),
            const SizedBox(height: 16), // Adjust spacing if needed
            ActionButton(
              iconData: Icons.save,
              onPressed: _saveItemsToDatabase,
              isDarkTheme: isDarkTheme,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  

  Widget _buildTextField(TextEditingController controller, String hintText,
      TextInputType keyboardType, bool isDarkTheme,
      [List<TextInputFormatter>? inputFormatters]) {
    return TextField(
      autofocus: true,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: hintText,
        hintText: hintText,
        labelStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        hintStyle: TextStyle(
          color: isDarkTheme ? Colors.grey : Colors.black54,
        ),
      ),
      style: TextStyle(
        color: isDarkTheme ? Colors.white : Colors.black,
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkTheme = themeProvider.isDarkTheme;

    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        color: isDarkTheme
            ? ThemeColors.darkCardColor
            : ThemeColors.lightCardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.robotoSerif(
                      textStyle: TextStyle(
                        color: isDarkTheme
                            ? ThemeColors.darkTextColor
                            : ThemeColors.lightTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Price: ${item.price.toString()}',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: isDarkTheme
                            ? ThemeColors.darkTextColor
                            : ThemeColors.lightTextColor,
                      ),
                    ),
                  ),
                  Text(
                    'Stocks: ${item.count.toString()}',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: isDarkTheme
                            ? ThemeColors.darkTextColor
                            : ThemeColors.lightTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: isDarkTheme
                    ? ThemeColors.darkIconColor
                    : ThemeColors.lightIconColor,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDarkTheme;
  final IconData iconData;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.isDarkTheme,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = isDarkTheme
        ? ThemeColors.darkButtonColor
        : ThemeColors.lightButtonColor;
    Color borderColor = iconColor.withOpacity(1); // Adjust opacity if needed
    return CircleAvatar(
      backgroundColor: borderColor,
      child: IconButton(
        icon: Icon(
          iconData,
          color: isDarkTheme
              ? ThemeColors.lightButtonTextColor
              : ThemeColors.darkButtonTextColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

