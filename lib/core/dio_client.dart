import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = 'https://api.spoonacular.com';
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  /// Fetch random recipes
  Future<List<dynamic>> fetchDummyRecipes({int count = 5}) async {
    try {
      print('Fetching dummy recipes...');
      final response = await _dio.get(
        '/recipes/random',
        queryParameters: {
          'number': count,
          'apiKey': '8951a8c77b3745898af7a0495ad85476', // Replace with your API key
        },
      );
      return response.data['recipes'] ?? [];
    } catch (e) {
      print('Error fetching dummy recipes: $e');
      return [];
    }
  }

  /// Fetch detailed recipe information by ID
  Future<Map<String, dynamic>> fetchRecipeDetails(String recipeId) async {
    try {
      print('Fetching recipe details for ID: $recipeId');
      final response = await _dio.get(
        '/recipes/$recipeId/information',
        queryParameters: {
          'includeNutrition': 'false',
          'apiKey': '8951a8c77b3745898af7a0495ad85476', // Replace with your API key
        },
      );
      return response.data;
    } catch (e) {
      print('Error fetching recipe details: $e');
      return {};
    }
  }
}
