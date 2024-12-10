import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe_card.dart';

class LoggedOutContent extends ConsumerWidget {
  const LoggedOutContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dummyRecipesAsync = ref.watch(dummyRecipesProvider);

    return dummyRecipesAsync.when(
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
    );
  }
}
