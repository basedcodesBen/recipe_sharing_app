import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = 'https://api.spoonacular.com';
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<List<dynamic>> fetchDummyRecipes({int count = 5}) async {
    try {
      print('Fetching dummy recipes...');
      final response = await _dio.get(
        '/recipes/random',
        queryParameters: {
          'number': count,
          'apiKey': '8951a8c77b3745898af7a0495ad85476', // Replace with your valid API key
        },
      );
      print('Request URL: ${response.realUri}');
      print('Response Data: ${response.data}');
      return response.data['recipes'] ?? [];
    } catch (e) {
      print('Error fetching dummy recipes: $e');
      return [];
    }
  }
}
