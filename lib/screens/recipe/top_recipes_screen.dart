import 'package:flutter/material.dart';

class TopRecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Recipes by Rating')),
      body: Center(child: Text('Top Recipes Content Here')),
    );
  }
}
