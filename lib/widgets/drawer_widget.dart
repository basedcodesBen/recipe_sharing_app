import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/auth/login_page.dart';
import '../providers/auth_provider.dart';
import '../screens/user-recipe/user_recipe_screen.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Drawer(
      child: authState.when(
        data: (user) {
          if (user != null) {
            // Logged-in user view
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerHeader(user),
                _buildDrawerOption(
                  context,
                  icon: Icons.edit,
                  text: 'Your Recipes',
                  onTap: () => _onYourRecipesPressed(context),
                ),
                _buildDrawerOption(
                  context,
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: () => _onLogoutPressed(context),
                ),
              ],
            );
          } else {
            // Guest user view
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerHeader(null),
                _buildDrawerOption(
                  context,
                  icon: Icons.login,
                  text: 'Login / Sign Up',
                  onTap: () => _onLoginSignUpPressed(context),
                ),
              ],
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading user data')),
      ),
    );
  }

  // Drawer header
  Widget _buildDrawerHeader(User? user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user?.displayName ?? 'Guest'),
      accountEmail: Text(user?.email ?? 'Please log in'),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Colors.blue),
      ),
    );
  }

  // Drawer option
  Widget _buildDrawerOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(text),
      onTap: onTap,
    );
  }

  // Navigate to Your Recipes screen
  void _onYourRecipesPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserRecipeScreen()),
    );
  }

  // Navigate to Login/Sign Up screen
  void _onLoginSignUpPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Logout the user
  void _onLogoutPressed(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context); // Close the drawer after logout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully!')),
    );
  }
}