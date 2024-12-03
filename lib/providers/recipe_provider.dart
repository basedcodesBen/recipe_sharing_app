import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/dio_client.dart';
import '../models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final dummyRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final dio = DioClient();
  final recipes = await dio.fetchDummyRecipes();
  return recipes.map((data) {
    return Recipe(
      id: data['id'].toString(),
      title: data['title'],
      description: data['summary'] ?? '',
      ingredients: [],
      imageUrl: data['image'],
      ownerId: 'dummy', // Placeholder for ownerId
      createdAt: DateTime.now(),
    );
  }).toList();
});

final firebaseRecipesProvider = StreamProvider<List<Recipe>>((ref) {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('recipes').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Recipe.fromFirestore(doc);
    }).toList();
  });
});

// Function to add a recipe and associate it with the current user
Future<void> addRecipe(Recipe recipe) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User must be logged in to add a recipe");
  }

  final recipeWithOwner = recipe.copyWith(ownerId: user.uid); // Associate the recipe with the logged-in user

  await FirebaseFirestore.instance.collection('recipes').add(recipeWithOwner.toMap());
}

// Function to edit a recipe (only by the owner)
Future<void> updateRecipe(Recipe recipe) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User must be logged in to edit a recipe");
  }

  if (recipe.ownerId != user.uid) {
    throw Exception("You are not authorized to edit this recipe");
  }

  await FirebaseFirestore.instance.collection('recipes').doc(recipe.id).update(recipe.toMap());
}

// Function to delete a recipe (only by the owner)
Future<void> deleteRecipe(String recipeId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User must be logged in to delete a recipe");
  }

  final recipeSnapshot = await FirebaseFirestore.instance.collection('recipes').doc(recipeId).get();
  final recipeData = recipeSnapshot.data();

  if (recipeData == null || recipeData['ownerId'] != user.uid) {
    throw Exception("You are not authorized to delete this recipe");
  }

  await FirebaseFirestore.instance.collection('recipes').doc(recipeId).delete();
}
