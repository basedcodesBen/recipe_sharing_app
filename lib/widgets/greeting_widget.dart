import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink(); // No widget if user is not logged in
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Welcome, ${user.displayName ?? user.email}!',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
