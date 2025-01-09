import 'package:flutter/material.dart';

class MainMealScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Meals'),
      ),
      body: const Center(
        child: Text(
          'Main Meals Recipes',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
