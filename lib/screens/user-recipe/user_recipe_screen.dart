import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../recipe/edit_recipe_screen.dart'; // Import your EditRecipeScreen
import '../../models/recipe.dart'; // Your Recipe model

class UserRecipeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Recipe>> _fetchUserRecipes() async {
    final user = _auth.currentUser;

    if (user == null) {
      return []; // Return empty list if user is not logged in
    }

    final querySnapshot = await _firestore
        .collection('recipes')
        .where('uid', isEqualTo: user.uid) // Fetch recipes belonging to the current user
        .get();

    return querySnapshot.docs.map((doc) {
      return Recipe.fromFirestore(doc); // Assuming your Recipe model has a fromFirestore method
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _fetchUserRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final recipes = snapshot.data;

          if (recipes == null || recipes.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return ListTile(
                title: Text(recipe.title),
                subtitle: Text(recipe.description),
                trailing: Icon(Icons.edit),
                onTap: () {
                  // Navigate to the EditRecipeScreen and pass the selected recipe
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditRecipeScreen(recipe: recipe),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
