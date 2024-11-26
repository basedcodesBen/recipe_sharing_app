import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = 'https://api.spoonacular.com';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'X-API-KEY': '8951a8c77b3745898af7a0495ad85476',
    };
  }

  Future<List<dynamic>> fetchDummyRecipes({int count = 5}) async {
    try {
      final response = await _dio.get(
        '/recipes/random',
        queryParameters: {'number': count},
      );
      return response.data['recipes'];
    } catch (e) {
      print('Error fetching dummy recipes: $e');
      return [];
    }
  }
}
