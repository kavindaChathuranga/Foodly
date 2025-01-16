import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart'; // For accessing writable directory
import 'dart:io'; // For file operations
import 'recipe_details_screen.dart'; // Import the new screen

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> filteredCategories = [];
  Map<String, bool> expandedCategories = {}; // Track expanded categories

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    // Get the writable directory path
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/recipes.json'; // Assuming the file is stored as recipes.json

    // Check if the file exists
    final file = File(filePath);
    if (await file.exists()) {
      // If the file exists, read and parse the JSON data
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      // Create a map for categories
      final Map<String, List<Map<String, dynamic>>> categoryMap = {};
      for (var item in jsonData) {
        final categoryName = item['category'] ?? 'No Category';
        if (!categoryMap.containsKey(categoryName)) {
          categoryMap[categoryName] = [];
        }
        categoryMap[categoryName]?.add(item);
      }

      // Now populate the categories list from the map
      setState(() {
        categories = categoryMap.entries
            .map((entry) => {'category': entry.key, 'recipes': entry.value})
            .toList();
        filteredCategories = categories;
      });
    } else {
      // Handle the case where the file does not exist
      print('File not found: $filePath');
      // Optionally, show a message to the user or load default data
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
              "Categories",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  final categoryName = category['category'] ?? 'No Name';
                  final recipes = category['recipes'] as List<dynamic>?;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            categoryName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (recipes != null && recipes.length > 2)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  expandedCategories[categoryName] =
                                      !(expandedCategories[categoryName] ??
                                          false);
                                });
                              },
                              child: const Text(
                                "See All",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFF4B3E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (recipes != null && recipes.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 167 / 218,
                          ),
                          itemCount: expandedCategories[categoryName] == true
                              ? recipes.length
                              : (recipes.length > 2 ? 2 : recipes.length),
                          itemBuilder: (context, recipeIndex) {
                            final recipe = recipes[recipeIndex];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailsScreen(
                                      recipe: recipe,
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 218,
                                width: 167,
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
                                              recipe['image'] ?? '',
                                              height: 174,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  recipe['name'] ??
                                                      'Unnamed Recipe',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Inter',
                                                  ),
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
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
