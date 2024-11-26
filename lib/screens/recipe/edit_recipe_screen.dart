import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe; // This parameter is passed from HomeScreen

  const EditRecipeScreen({super.key, required this.recipe});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.recipe.title;
    descriptionController.text = widget.recipe.description;
    ingredientsController.text = widget.recipe.ingredients.join(', ');
    imageUrlController.text = widget.recipe.imageUrl ?? '';
  }

  Future<void> updateRecipe() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Description cannot be empty!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('recipes').doc(widget.recipe.id).update({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'ingredients': ingredientsController.text
            .split(',')
            .map((ingredient) => ingredient.trim())
            .toList(),
        'imageUrl': imageUrlController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe updated successfully!')));

      Navigator.pop(context, true); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
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
      appBar: AppBar(title: const Text('Edit Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients (comma-separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: updateRecipe,
                      child: const Text('Update Recipe'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
