import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';
import '../recipe/edit_recipe_screen.dart';
import '../../models/recipe.dart';
import '../auth/login_page.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final dummyRecipesAsync = ref.watch(dummyRecipesProvider);
    final firebaseRecipesAsync = ref.watch(firebaseRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Savorly',
          style: TextStyle(
            color: Colors.black, 
          ),
        ),
        backgroundColor: Colors.white, 
        iconTheme: const IconThemeData(color: Colors.black), 
        actions: [
          if (user == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text(
                  'Login/Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully!')),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: firebaseRecipesAsync.when(
        data: (firebaseRecipes) => dummyRecipesAsync.when(
          data: (dummyRecipes) {
            // Combine both recipe lists
            final combinedRecipes = [
              ...firebaseRecipes.map((recipe) => {
                    "recipe": recipe,
                    "subtitle": "User-contributed recipe",
                    "source": "Firebase",
                    "onEdit": () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRecipeScreen(recipe: recipe),
                        ),
                      );
                      if (result == true) {
                        ref.refresh(firebaseRecipesProvider);
                      }
                    },
                  }),
              ...dummyRecipes.map((recipe) => {
                    "recipe": recipe,
                    "subtitle": "Recipe from Spoonacular API",
                    "source": "API",
                    "onEdit": null,
                  }),
            ];

            return ListView.builder(
              itemCount: combinedRecipes.length,
              itemBuilder: (context, index) {
                final entry = combinedRecipes[index];
                final recipe = entry["recipe"] as Recipe;
                final subtitle = entry["subtitle"] as String;
                final onEdit = entry["onEdit"] as VoidCallback?;

                return RecipeCard(
                  recipe: recipe,
                  onEdit: onEdit,
                  subtitle: subtitle,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
