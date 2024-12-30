// import 'package:flutter/material.dart';
// import '../../models/recipe.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../screens/recipe/edit_recipe_screen.dart';

// class RecipeCard extends StatelessWidget {
//   final Recipe recipe;
//   final VoidCallback? onEdit;
//   final String subtitle;

//   const RecipeCard({
//     super.key,
//     required this.recipe,
//     this.onEdit,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Recipe title
//             Text(
//               recipe.title,
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 4),
//             // Recipe subtitle
//             Text(
//               subtitle,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     fontStyle: FontStyle.italic,
//                     color: Colors.grey[700],
//                   ),
//             ),
//             const SizedBox(height: 8),
//             // Recipe description
//             Text(
//               recipe.description,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             const SizedBox(height: 8),
//             // Recipe image
//             if (recipe.imageUrl.isNotEmpty)
//               Image.network(
//                 recipe.imageUrl,
//                 fit: BoxFit.cover,
//                 height: 150,
//                 width: double.infinity,
//               ),
//             const SizedBox(height: 8),
//             if (user != null && user.uid == recipe.ownerId)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton.icon(
//                     onPressed: () async {
//                       final result = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditRecipeScreen(recipe: recipe),
//                         ),
//                       );

//                       if (result == true && onEdit != null) {
//                         onEdit!();
//                       }
//                     },
//                     icon: const Icon(Icons.edit),
//                     label: const Text('Edit'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../screens/recipe/recipe_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onEdit;
  final String subtitle;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onEdit,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              recipeId: recipe.id,
              isUserRecipe: recipe.ownerId != 'dummy', // Differentiates user-contributed vs API recipes
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe title
              Text(
                recipe.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              // Recipe subtitle
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // Recipe description
              Text(
                recipe.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              // Recipe image
              if (recipe.imageUrl.isNotEmpty)
                Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              const SizedBox(height: 8),
              // Action buttons (Edit)
              if (user != null && user.uid == recipe.ownerId)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
