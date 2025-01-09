import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodlyApp extends StatefulWidget {
  const FoodlyApp({super.key});
  @override
  _FoodlyAppState createState() => _FoodlyAppState();
}

class _FoodlyAppState extends State<FoodlyApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: const Color(0xFFFF4B3E),
        unselectedItemColor: const Color(0xFF1A1A1A),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/home.svg',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 0
                      ? const Color(0xFFFF4B3E)
                      : const Color(0xFF1A1A1A),
                ),
                const SizedBox(height: 3),
              ],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/categories.svg',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 1
                      ? const Color(0xFFFF4B3E)
                      : const Color(0xFF1A1A1A),
                ),
                const SizedBox(height: 3),
              ],
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/favorites.svg',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 2
                      ? const Color(0xFFFF4B3E)
                      : const Color(0xFF1A1A1A),
                ),
                const SizedBox(height: 3),
              ],
            ),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> recipes = [
    {
      'name': 'Chicken Curry',
      'time': '50 m',
      'image': 'assets/images/Chicken_Curry.png'
    },
    {
      'name': 'Pork Kottu',
      'time': '35 m',
      'image': 'assets/images/Pork_Kottu.png'
    },
    {
      'name': 'Chicken Biriyani',
      'time': '1.5 hr',
      'image': 'assets/images/Chicken_Biriyani.png'
    },
    {
      'name': 'Mac and Cheese',
      'time': '45 m',
      'image': 'assets/images/Pork_Kottu.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 68),
            const Text(
              "What's your recipe\npick today?",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFE8E8E8),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Padding(
              padding:
              EdgeInsets.only(left: 5.0), // Adds 5px padding to the left
              child: Text(
                'Explore',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.only(top: 2), // Reduce top margin by 15px
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cards per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                    167 / 218, // Adjust to match card dimensions
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to recipe details
                      },
                      child: SizedBox(
                        height: 218, // Set card height
                        width: 167, // Set card width
                        child: Card(
                          color: const Color(0xFFE0E0E0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    child: Image.asset(
                                      recipe['image']!,
                                      height: 174,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          recipe['name']!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Color(0xFF1A1A1A),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 10,
                                right: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF4B3E),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        size: 14,
                                        color: Color(0xFFF5F5F5),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        recipe['time']!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFF5F5F5),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categoriesWithRecipes = [
    {
      'category': 'Main Meals',
      'recipes': [
        {
          'name': 'Beef Fried Rice',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '30 m',
        },
        {
          'name': 'Pork Kottu',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '35 m',
        },
        {
          'name': 'Chicken Biriyani',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '1 hr',
        },
        {
          'name': 'Mac and Cheeses',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '45 m',
        },
        {
          'name': 'Spaghetti with Meat',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '40 m',
        },
        {
          'name': 'Noodles',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '25 m',
        },
      ],
    },
    {
      'category': 'Lunch',
      'recipes': [
        {
          'name': 'Grilled Chicken',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '50 m',
        },
        {
          'name': 'Caesar Salad',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '20 m',
        },
        {
          'name': 'Pasta',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '30 m',
        },
      ],
    },
    {
      'category': 'Dinner',
      'recipes': [
        {
          'name': 'Steak',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '1 hr',
        },
        {
          'name': 'Soup',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '40 m',
        },
        {
          'name': 'Pizza',
          'image': 'assets/images/Pork_Kottu.png',
          'time': '30 m',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth / 3 - 16; // Divide screen width by 3 and subtract spacing

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Makes the title bold
            fontSize: 20, // Optional: Adjust font size
          ),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black, // AppBar text color set to black
      ),
      body: Container(
        color: const Color(0xFFF5F5F5), // Light gray background color for the whole screen
        child: ListView.builder(
          itemCount: categoriesWithRecipes.length,
          itemBuilder: (context, index) {
            final category = categoriesWithRecipes[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      category['category'] ?? 'Unknown Category', // Handle null values
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Horizontal card slider for the category
                  SizedBox(
                    height: 180, // Decreased card height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: category['recipes']?.length ?? 0, // Handle null list
                      itemBuilder: (context, recipeIndex) {
                        final recipe = category['recipes']?[recipeIndex];
                        if (recipe == null) return Container(); // Handle null recipes

                        return Container(
                          width: cardWidth, // Adjust card width to fit 3 cards
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  child: Image.asset(
                                    recipe['image'] ?? 'assets/images/default.png', // Handle null image
                                    height: 90, // Reduced image height
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe['name'] ?? 'Unnamed Recipe', // Handle null name
                                        style: const TextStyle(
                                          fontSize: 14, // Adjusted font size
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Displaying the time
                                      Text(
                                        recipe['time'] ?? 'Unknown Time', // Handle null time
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Favorites Page'));
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FoodlyApp(),
  ));
}