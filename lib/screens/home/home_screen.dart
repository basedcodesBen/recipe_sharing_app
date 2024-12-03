import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';
import '../../widgets/greeting_widget.dart';
import '../auth/login_page.dart';
import '../recipe/edit_recipe_screen.dart';
import '../../models/recipe.dart';
import '../../core/auth_service.dart';
import '../../widgets/drawer_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();
    final dummyRecipesAsync = ref.watch(dummyRecipesProvider);
    final firebaseRecipesAsync = ref.watch(firebaseRecipesProvider);

    return authService.authStateWrapper(
      loggedInWidget: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: const Text('Savorly'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Open the Drawer when the hamburger menu button is pressed
              Scaffold.of(context).openDrawer();
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await authService.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully!')),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(), // Adding the Drawer widget here
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting widget displaying user's name if logged in
            GreetingWidget(),
            Expanded(
              child: firebaseRecipesAsync.when(
                data: (firebaseRecipes) => dummyRecipesAsync.when(
                  data: (dummyRecipes) {
                    final combinedRecipes = [
                      ...firebaseRecipes.map((recipe) => {
                            "recipe": recipe,
                            "subtitle": "User-contributed recipe",
                            "source": "Firebase",
                            "onEdit": () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditRecipeScreen(recipe: recipe),
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
      loggedOutWidget: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: const Text('Savorly'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text(
                'Login/Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(), // Adding the Drawer widget here
        body: dummyRecipesAsync.when(
          data: (dummyRecipes) {
            return ListView.builder(
              itemCount: dummyRecipes.length,
              itemBuilder: (context, index) {
                final recipe = dummyRecipes[index];
                return RecipeCard(
                  recipe: recipe,
                  subtitle: 'Recipe from Spoonacular API',
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
