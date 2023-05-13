import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<Response> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await _dio
          .post('https://api.eskanist.com/public/api/login', data: data);
      return response;
    } catch (e) {
      throw Exception('Login request failed');
    }
  }

  Future<Response> register(String name, String email, String password,
      String confirmPassword) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    try {
      final response = await _dio
          .post('https://api.eskanist.com/public/api/register', data: data);
      return response;
    } catch (e) {
      throw Exception('Register request failed');
    }
  }
}
