import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final String? imageUrl;
  final String ownerId; // 'dummy' for API recipes, Firebase UID for user recipes
  final DateTime createdAt;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    this.imageUrl,
    required this.ownerId,
    required this.createdAt,
  });

  // Create Recipe from Firestore
  factory Recipe.fromFirestore(String id, Map<String, dynamic> data) {
    return Recipe(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      imageUrl: data['imageUrl'],
      ownerId: data['ownerId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert Recipe to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'createdAt': createdAt,
    };
  }
}
