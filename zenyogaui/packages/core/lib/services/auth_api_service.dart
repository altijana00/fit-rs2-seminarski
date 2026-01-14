import 'package:dio/dio.dart';

class AuthApiService {
  final Dio dio;

  AuthApiService(this.dio);

  // Expecting API returns { "token": "..." } or { "access_token": "..." }
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      'Auth/login',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Login failed: ${response.data}');
    }
  }
  
  Future<Map<String, dynamic>> getUserById(int id) async {
    final response = await dio.get('User/getById?id=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch user: ${response.data}');
    }
  }


}