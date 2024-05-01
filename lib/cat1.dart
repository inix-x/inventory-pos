import 'package:flutter/material.dart';

void main() {
  runApp(const Cat1());
}

class Cat1 extends StatelessWidget {
  const Cat1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:   Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Center(child: Text('Point of Sale App', style: TextStyle(color: Colors.white))),
        ),
        body: Row(
          children: [ 
            const SizedBox(
              width: 50.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_food_beverage_rounded),
                  Icon(Icons.fastfood_rounded),
                  Icon(Icons.cake_rounded),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0), // Adjust padding as needed
                child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: 1, // Square aspect ratio
                  crossAxisCount: 2,
                  crossAxisSpacing: 30.0,
                  mainAxisSpacing: 30, // Spacing between grid items
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 1',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 2',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 3',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 4',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 5',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 6',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 7',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 8',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 9',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 3 / 2, // Adjust width-to-height ratio
                      child: Container(
                        color: Colors.grey[300], // Set background color
                        child: const Center(
                          child: Text(
                            'Grid Item 10',
                            style: TextStyle(fontSize: 16.0), // Adjust font size
                          ),
                        ),
                      ),
                    ),
                    // ... Add more grid items with similar structure
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.shopping_basket_sharp),
          onPressed: () {
            // Function handler
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
