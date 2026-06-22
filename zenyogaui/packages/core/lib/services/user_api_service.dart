import 'dart:io';

import 'package:core/dto/requests/update_your_user_password_dto.dart';
import 'package:dio/dio.dart';

import '../dto/requests/update_user_password_as_admin_dto.dart';

class UserApiService {
  final Dio dio;

  UserApiService(this.dio);

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

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await dio.get('User/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
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
        options: Options(
          validateStatus: (status) => true,
        )
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
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
      throw Exception('Falied to fetch users: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> addUser(Map<String, dynamic> userData) async {
    final response = await dio.post(
      'User/add?',
      data: userData,
        options: Options(
          validateStatus: (status) => true,
        )
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
      throw Exception('Failed to register user: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await dio.post(
      'User/register?',
      data: userData,
        options: Options(
          validateStatus: (status) => true,
        )
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
      throw Exception('Failed to register user: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> editUser(Map<String, dynamic> userData, int userId) async {
    final response = await dio.put(
      'User/edit?id=$userId',
      data: userData,
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201){
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
        options: Options(
          validateStatus: (status) => true,
        )
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
      throw Exception('Failed to delete user: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> updateUserPasswordAsAdmin(Map<String, dynamic> updateUserPasswordAsAdminDto) async {
    final response = await dio.put(
      'User/updateUserPassword',
        data: updateUserPasswordAsAdminDto,
        options: Options(
          validateStatus: (status) => true,
        )
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
      throw Exception('Failed to update password: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> updateYourUserPassword(Map<String, dynamic> updateYourUserPasswordDto) async {
    final response = await dio.put(
      'User/updateYourUserPassword',
        data: updateYourUserPasswordDto,
        options: Options(
          validateStatus: (status) => true,
        )
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
      throw Exception('Failed to update password: ${response.data}');
    }
  }

  Future<String> uploadUserPhoto(File imageFile) async {
    final fileName = imageFile.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      'User/uploadUserPhoto',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
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
      throw Exception('Failed to upload photo');
    }
  }

  Future<String> editUserPhoto(String photoURL, int userId) async {
    final response = await dio.patch(
        'User/editUserPhoto?photoUrl=$photoURL&userId=$userId'
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
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
      throw Exception('Failed to edit photo: ${response.data}');
    }
  }
}