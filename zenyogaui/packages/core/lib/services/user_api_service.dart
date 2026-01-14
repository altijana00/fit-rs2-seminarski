import 'package:core/dto/requests/update_user_password_dto.dart';
import 'package:dio/dio.dart';

class UserApiService {
  final Dio dio;

  UserApiService(this.dio);

  Future<Map<String, dynamic>> getUserById(int id) async {
    final response = await dio.get('User/getById?id=$id');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch user: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await dio.get('User/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch users: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getUsersQuery(String? search, int? roleId, int? cityId) async {
    final response = await dio.get('User/getUsersQuery',
    queryParameters: {
      if(search != null) 'search': search,
      if(roleId != null) 'roleId' : roleId,
      if(cityId != null) 'cityId' : cityId,
    },
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch users: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> addUser(Map<String, dynamic> userData) async {
    final response = await dio.post(
      'User/add?',
      data: userData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to register user: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> editUser(Map<String, dynamic> userData, int userId) async {
    final response = await dio.put(
      'User/edit?id=$userId',
      data: userData,
    );

    if (response.statusCode == 200 || response.statusCode == 201){
      return Map<String, dynamic>.from(response.data);

    } else if (response.statusCode == 500) {
      var resp = Map<String, dynamic>.from(response.data);
      throw Exception(resp["error"]);

    } else{
      throw Exception('Failed to edit user: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> deleteUser(int userId) async {
    final response = await dio.delete(
      'User/delete?id=$userId',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to delete user: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> updateUserPassword(UpdateUserPasswordDto updateUserPasswordDto, String token) async {
    final response = await dio.patch(
      'User/updateUserPassword?UserId=${updateUserPasswordDto.id}&OldPassword=${updateUserPasswordDto.oldPassword}&NewPassword=${updateUserPasswordDto.newPassword}&token=$token',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to update password: ${response.data}');
    }
  }
}