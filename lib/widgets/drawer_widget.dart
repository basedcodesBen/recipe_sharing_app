import 'package:flutter/material.dart';
import '../core/auth_service.dart';
import '../screens/auth/login_page.dart';
import '../screens/user-recipe/user_recipe_screen.dart';

class DrawerWidget extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerOption(
            context,
            icon: Icons.edit,
            text: 'Your Recipes',
            onTap: () => _onUserRecipesPressed(context),
          ),
          Divider(),
          _buildAuthSection(context),
        ],
      ),
    );
  }

  // Build the header of the drawer
  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(_authService.currentUser?.displayName ?? 'Guest'),
      accountEmail: Text(_authService.currentUser?.email ?? 'Please log in'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Colors.blue),
      ),
    );
  }

  // Build a single option in the drawer
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

  // Handle User Recipes button press
  void _onUserRecipesPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserRecipeScreen()),
    );
  }

  // Auth Section - Login/Sign up or Logout depending on user status
  Widget _buildAuthSection(BuildContext context) {
    final user = _authService.currentUser;

    return user == null
        ? Column(
            children: [
              _buildDrawerOption(
                context,
                icon: Icons.login,
                text: 'Login / Sign Up',
                onTap: () => _onLoginSignUpPressed(context),
              ),
            ],
          )
        : Column(
            children: [
              _buildDrawerOption(
                context,
                icon: Icons.exit_to_app,
                text: 'Logout',
                onTap: () => _onLogoutPressed(context),
              ),
            ],
          );
  }

  // Handle Login/Sign Up button press
  void _onLoginSignUpPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Handle Logout button press
  void _onLogoutPressed(BuildContext context) {
    _authService.signOut();
    Navigator.pop(context); // Close the drawer
  }
}
