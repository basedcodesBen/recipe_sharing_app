import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String ownerId; // Added ownerId to associate recipe with the user
  final DateTime createdAt;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ownerId,
    required this.createdAt,
    required this.ingredients,
  });

  // Convert Firestore document to Recipe object
  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Recipe(
      id: doc.id,
      title: data['title'],
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      ownerId: data['ownerId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      ingredients: List<String>.from(data['ingredients'] ?? []),
    );
  }

  // Convert Recipe object to Firestore-friendly map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'createdAt': createdAt,
      'ingredients': ingredients,
    };
  }

  // Implementing copyWith method to allow updating fields while keeping others unchanged
  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? ownerId,
    DateTime? createdAt,
    List<String>? ingredients,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}

