import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart'; // For loading assets

class RecipeDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late bool isFavorite;
  late List<dynamic> recipes; // Store the list of recipes
  bool isDataLoaded = false; // Track whether the data has been loaded

  @override
  void initState() {
    super.initState();
    isFavorite = widget.recipe['isFavorite'] ?? false; // Initialize isFavorite here
    _loadRecipes();
  }

  // Load recipes from the writable directory or assets
  Future<void> _loadRecipes() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/recipes.json');

    if (await file.exists() && !isDataLoaded) {
      // If the file exists and data is not already loaded
      final recipesJson = await file.readAsString();
      setState(() {
        recipes = jsonDecode(recipesJson);
        isDataLoaded = true;
      });
      // Find the current recipe and update the favorite status
      isFavorite = _getFavoriteStatus();
    } else if (!isDataLoaded) {
      // If the file doesn't exist, load from assets
      final String data = await rootBundle.loadString('assets/recipes.json');
      final List<dynamic> defaultRecipes = jsonDecode(data);
      setState(() {
        recipes = defaultRecipes;
        isDataLoaded = true;
      });
      // Write default data to the writable directory
      await file.writeAsString(jsonEncode(defaultRecipes));
      isFavorite = widget.recipe['isFavorite'] ?? false;
    }
  }

  // Function to get the favorite status of the current recipe
  bool _getFavoriteStatus() {
    final recipe = recipes.firstWhere(
          (r) => r['name'] == widget.recipe['name'],
      orElse: () => widget.recipe,
    );
    return recipe['isFavorite'] ?? false;
  }

  // Function to update the JSON file and print updated content to console
  Future<void> updateFavoriteStatus(bool status) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/recipes.json');

    // Update the favorite status in the recipes list
    final updatedRecipes = recipes.map((recipe) {
      if (recipe['name'] == widget.recipe['name']) {
        recipe['isFavorite'] = status;
      }
      return recipe;
    }).toList();

    // Write the updated recipes back to the file
    await file.writeAsString(jsonEncode(updatedRecipes));

    // Print the updated content to the console
    print('Updated Recipes:');
    updatedRecipes.forEach((recipe) {
      print(jsonEncode(recipe));
    });

    setState(() {
      recipes = updatedRecipes;
      isFavorite = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF4B3E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    widget.recipe['image'],
                    width: MediaQuery.of(context).size.width, // Full width
                    fit: BoxFit.cover, // Optional: adjust to cover the space
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 12.0),
                      color: Colors.black.withOpacity(0.6),
                      child: Text(
                        widget.recipe['time'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align name and favorite button
                children: [
                  Text(
                    widget.recipe['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFFFF4B3E),
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      updateFavoriteStatus(isFavorite);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Ingredients:',
                style: Theme.of(context).textTheme.titleLarge, // Use titleLarge for display
              ),
              const SizedBox(height: 10),
              ...widget.recipe['ingredients'].map<Widget>((ingredient) {
                return Text('• $ingredient');
              }).toList(),
              const SizedBox(height: 20),
              Text(
                'Instructions:',
                style: Theme.of(context).textTheme.titleLarge, // Use titleLarge for display
              ),
              const SizedBox(height: 10),
              ...widget.recipe['instructions'].map<Widget>((instruction) {
                return Text('• $instruction');
              }).toList(),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Preparation Time: '),
                  Text(widget.recipe['time']),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
