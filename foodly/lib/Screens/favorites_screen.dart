import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'recipe_details_screen.dart'; // Import your RecipeDetailsScreen

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      // Get the writable directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/recipes.json');

      // Check if the file exists
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> data = jsonDecode(content);

        // Filter only favorite recipes
        setState(() {
          favoriteRecipes = data
              .where((recipe) => recipe['isFavorite'] == true)
              .cast<Map<String, dynamic>>()
              .toList();
        });
      } else {
        // If file doesn't exist, initialize it
        print("Favorites file not found. Initializing.");
        await file.writeAsString('[]');
      }
    } catch (e) {
      print("Error reading favorites: $e");
    }
  }

  Future<void> _removeFavorite(Map<String, dynamic> recipe) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/recipes.json');

      if (await file.exists()) {
        final content = await file.readAsString();
        List<dynamic> data = jsonDecode(content);

        // Find and update the recipe's favorite status
        for (var i = 0; i < data.length; i++) {
          if (data[i]['name'] == recipe['name']) {
            data[i]['isFavorite'] = false;
            break;
          }
        }

        // Write updated data back to file
        await file.writeAsString(jsonEncode(data));

        // Reload favorites
        setState(() {
          favoriteRecipes.removeWhere((r) => r['name'] == recipe['name']);
        });

        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                  vertical: 2), // Increase vertical padding
              child: Text(
                'Removed',
                style: const TextStyle(
                    fontSize: 17,
                    color: const Color(0xFFF5F5F5),
                    fontWeight: FontWeight.w500), // Optional: Adjust font size
              ),
            ),
            backgroundColor: const Color(0xFFFF7b71),
            duration: const Duration(seconds: 2),
            width: 110,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print("Error removing favorite: $e");
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
              "Favorites",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            favoriteRecipes.isEmpty
                ? const Center(
                    child: Text(
                      "No favorites yet!",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: favoriteRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = favoriteRecipes[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to RecipeDetailsScreen with the selected recipe
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailsScreen(
                                  recipe: recipe,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(10),
                                  ),
                                  child: Image.asset(
                                    recipe['image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      recipe['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: const Color(0xFFFF4B3E),
                                    size: 26,
                                  ),
                                  onPressed: () => _removeFavorite(recipe),
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
      ),
    );
  }
}
