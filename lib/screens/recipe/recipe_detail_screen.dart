import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/recipe.dart';
import '../../core/dio_client.dart';
import '../recipe/edit_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;
  final bool isUserRecipe; 

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    this.isUserRecipe = false,
  });

  Future<Map<String, dynamic>> fetchApiRecipeDetails(String recipeId) async {
    final dioClient = DioClient();
    return await dioClient.fetchRecipeDetails(recipeId);
  }

  Future<Recipe> fetchUserRecipeDetails(String recipeId) async {
    final doc = await FirebaseFirestore.instance.collection('recipes').doc(recipeId).get();
    return Recipe.fromFirestore(doc);
  }

  Future<void> deleteRecipe(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("You must be logged in to delete a recipe.");
    }

    final doc = await FirebaseFirestore.instance.collection('recipes').doc(recipeId).get();
    if (doc.data()?['ownerId'] != user.uid) {
      throw Exception("You can only delete your own recipes.");
    }

    await FirebaseFirestore.instance.collection('recipes').doc(recipeId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        actions: isUserRecipe
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRecipeScreen(
                          recipe: Recipe(
                            id: recipeId,
                            title: '',
                            description: '',
                            imageUrl: '',
                            ownerId: '',
                            createdAt: DateTime.now(),
                            ingredients: [],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await deleteRecipe(recipeId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recipe deleted successfully!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                ),
              ]
            : null,
      ),
      body: isUserRecipe
          ? FutureBuilder<Recipe>(
              future: fetchUserRecipeDetails(recipeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final recipe = snapshot.data!;
                  return _buildRecipeDetails(context, recipe);
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            )
          : FutureBuilder<Map<String, dynamic>>(
              future: fetchApiRecipeDetails(recipeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return _buildApiRecipeDetails(context, data);
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
    );
  }

  Widget _buildRecipeDetails(BuildContext context, Recipe recipe) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (recipe.imageUrl.isNotEmpty)
              Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            const SizedBox(height: 16),
            Text(
              recipe.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...recipe.ingredients.map((ingredient) => Text(
                  '- $ingredient',
                  style: const TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildApiRecipeDetails(BuildContext context, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (data['image'] != null)
              Image.network(
                data['image'],
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            const SizedBox(height: 16),
            Text(
              data['summary'] ?? 'No Description',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...List<Widget>.from((data['extendedIngredients'] ?? [])
                .map((ingredient) => Text(
                      '- ${ingredient['name']}',
                      style: const TextStyle(fontSize: 16),
                    ))),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              data['instructions'] ?? 'No Instructions Available',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
