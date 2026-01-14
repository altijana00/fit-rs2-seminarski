import 'package:dio/dio.dart';

class RoleApiService {
  final Dio dio;

  RoleApiService(this.dio);

  Future<Map<String, dynamic>> getRoleById(int id) async {
    final response = await dio.get('Role/getById?id=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch role: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllRoles() async {
    final response = await dio.get('Role/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch roles: ${response.data}');
    }
  }


}