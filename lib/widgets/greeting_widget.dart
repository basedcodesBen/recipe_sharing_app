import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GreetingWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        user == null
            ? 'Hello, Guest! Please log in.'
            : 'Hello, ${user.displayName}!',
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}