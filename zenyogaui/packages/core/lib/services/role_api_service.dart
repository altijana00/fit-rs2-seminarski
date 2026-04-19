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

  Future<List<Map<String, dynamic>>> getRolesQuery(String? search) async {
    final response = await dio.get('Role/getRolesQuery',
      queryParameters: {
        if(search != null) 'search': search,
      },
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch roles: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> deleteRole(int roleId) async {
    final response = await dio.delete(
      'Role/delete?id=$roleId',
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to delete role: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> editRole(Map<String, dynamic> roleData, int roleId) async {
    final response = await dio.put(
        'Role/edit?id=$roleId',
        data: roleData,
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201){
      return response.data;

    } else if (response.statusCode == 500) {
      var resp = response.data;
      throw Exception(resp["error"]);

    } else{
      throw Exception('Failed to edit role: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> addRole(Map<String, dynamic> roleData) async {
    final response = await dio.post(
        'Role/add',
        data: roleData,
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else if (response.statusCode == 400) {
      var resp = Map<String, dynamic>.from(response.data);
      throw Exception(resp["error"]);
    } else {
      throw Exception('Failed to add role: ${response.data}');
    }
  }


}