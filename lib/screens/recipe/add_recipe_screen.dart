import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  Future<void> _addRecipe() async {
    final user = _auth.currentUser;
    if (user == null) {
      // Handle case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to add a recipe')),
      );
      return;
    }

    final name = _nameController.text;
    final ingredients = _ingredientsController.text;
    final instructions = _instructionsController.text;

    if (name.isEmpty || ingredients.isEmpty || instructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return; // Handle empty fields
    }

    final recipeData = {
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'uid': user.uid,  // Associate recipe with the user
      'createdAt': Timestamp.now(),
    };

    setState(() {
      isLoading = true;
    });

    try {
      await _firestore.collection('recipes').add(recipeData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe added successfully!')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      print('Error adding recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add recipe')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            TextField(
              controller: _instructionsController,
              decoration: InputDecoration(labelText: 'Instructions'),
            ),
            SizedBox(height: 16.0),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _addRecipe,
                    child: Text('Add Recipe'),
                  ),
          ],
        ),
      ),
    );
  }
}
