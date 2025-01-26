import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'recipe_details_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> filteredCategories = [];
  Map<String, bool> expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/recipes.json';

    final file = File(filePath);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      final Map<String, List<Map<String, dynamic>>> categoryMap = {};
      for (var item in jsonData) {
        final categoryName = item['category'] ?? 'No Category';
        if (!categoryMap.containsKey(categoryName)) {
          categoryMap[categoryName] = [];
        }
        categoryMap[categoryName]?.add(item);
      }

      setState(() {
        categories = categoryMap.entries
            .map((entry) => {'category': entry.key, 'recipes': entry.value})
            .toList();
        filteredCategories = categories;
      });
    } else {
      print('File not found: $filePath');
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
                              child: Text(
                                expandedCategories[categoryName] == true
                                    ? "Hide"
                                    : "See All",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFFFF4B3E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (recipes != null && recipes.isNotEmpty)
                        expandedCategories[categoryName] == true
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 110 / 152,
                                ),
                                itemCount: recipes.length,
                                itemBuilder: (context, recipeIndex) {
                                  final recipe = recipes[recipeIndex];
                                  return _buildRecipeCard(recipe);
                                },
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: recipes.map((recipe) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: _buildRecipeCard(recipe),
                                    );
                                  }).toList(),
                                ),
                              ),
                      const SizedBox(height: 20),
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

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(recipe: recipe),
          ),
        );
      },
      child: SizedBox(
        height: 152,
        width: 130,
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
                      recipe['image'] ?? '',
                      height: 112,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          recipe['name'] ?? 'Unnamed Recipe',
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
              Positioned(
                top: 8,
                right: 2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF4B3E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        recipe['time'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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
  }
}
