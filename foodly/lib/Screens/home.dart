import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required to load assets
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
        selectedItemColor: const Color(0xFFFF4B3E), // Highlight color
        unselectedItemColor: const Color(0xFF1A1A1A),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600, // Bold text for all labels
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600, // Bold text for all labels
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
                const SizedBox(height: 3), // Space between icon and label
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
                const SizedBox(height: 3), // Space between icon and label
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
                const SizedBox(height: 3), // Space between icon and label
              ],
            ),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> recipes;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    recipes = loadRecipes();
  }

  Future<List<Map<String, dynamic>>> loadRecipes() async {
    final String jsonString =
        await rootBundle.loadString('assets/recipes.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse
        .map((recipe) => recipe as Map<String, dynamic>)
        .toList();
  }

  void _filterRecipes(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredRecipes = [];
      });
    } else {
      setState(() {
        filteredRecipes = filteredRecipes
            .where((recipe) =>
                recipe['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

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
              controller: searchController,
              onChanged: _filterRecipes,
              decoration: InputDecoration(
                hintText: 'Search',
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
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: recipes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final recipesData = snapshot.data ?? [];
                    if (filteredRecipes.isEmpty) {
                      filteredRecipes = recipesData;
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 cards per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            167 / 218, // Adjust to match card dimensions
                      ),
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to recipe details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            );
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
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
                                                vertical: 10),
                                            child: Text(
                                              recipe['name']!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']!),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                recipe['image']!,
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              const Text(
                'Ingredients:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              ...List<Widget>.from(
                recipe['ingredients'].map<Widget>((ingredient) {
                  return Text(
                    ingredient!,
                    style: const TextStyle(fontSize: 16),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Text(
                'Instructions:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              ...List<Widget>.from(
                recipe['instructions'].map<Widget>((instruction) {
                  return Text(
                    instruction!,
                    style: const TextStyle(fontSize: 16),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Categories Page'));
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Favorites Page'));
  }
}
