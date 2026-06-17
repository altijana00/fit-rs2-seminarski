import 'package:dio/dio.dart';

class AuthApiService {
  final Dio dio;

  AuthApiService(this.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      'Auth/login',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    } else {
      throw Exception('Login failed: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await dio.post(
      'Auth/logout',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    } else {
      throw Exception('Logout failed: ${response.data}');
    }
  }
  
  Future<Map<String, dynamic>> getUserById(int id) async {
    final response = await dio.get('User/getById?id=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    } else {
      throw Exception('Falied to fetch user: ${response.data}');
    }
  }


}