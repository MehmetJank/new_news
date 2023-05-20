import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.qline.app/api';

  Future<dynamic> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await _dio.post('$_baseUrl/login', data: data);
      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          return res;
        } else {
          // error = response.data["msg"];
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return null;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Login request failed');
    }
  }

  Future<dynamic> register(String name, String email, String password,
      String confirmPassword) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    try {
      final response = await _dio.post('$_baseUrl/register', data: data);
      if (response.statusCode == 200) {
        if (response.data["success"]) {
          var res = response.data;
          return res;
        } else {
          // error = response.data["msg"];
          return null;
        }
      } else if (response.statusCode == 404) {
        // wrong user password
        return null;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Register request failed');
    }
  }
}
