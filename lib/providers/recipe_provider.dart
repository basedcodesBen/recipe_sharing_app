import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/dio_client.dart';
import '../models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      ownerId: 'dummy',
      createdAt: DateTime.now(),
    );
  }).toList();
});

final firebaseRecipesProvider = StreamProvider<List<Recipe>>((ref) {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('recipes').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Recipe.fromFirestore(doc.id, data);
    }).toList();
  });
});
