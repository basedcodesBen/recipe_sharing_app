import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';

class LoggedInContent extends ConsumerWidget {
  const LoggedInContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseRecipesAsync = ref.watch(firebaseRecipesProvider);
    final dummyRecipesAsync = ref.watch(dummyRecipesProvider);

    return firebaseRecipesAsync.when(
      data: (firebaseRecipes) => dummyRecipesAsync.when(
        data: (dummyRecipes) {
          final combinedRecipes = [
            ...firebaseRecipes,
            ...dummyRecipes,
          ];

          return ListView.builder(
            itemCount: combinedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = combinedRecipes[index];
              return RecipeCard(recipe: recipe, subtitle: 'Recipe');
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
