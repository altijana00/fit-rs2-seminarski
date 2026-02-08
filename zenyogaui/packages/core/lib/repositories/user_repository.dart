
import 'dart:io';

import 'package:core/dto/requests/update_user_password_dto.dart';

import '../dto/requests/edit_user_dto.dart';
import '../dto/requests/register_user_dto.dart';
import '../dto/responses/user_response_dto.dart';
import '../services/user_api_service.dart';

class UserRepository {
  final UserApiService api;

  UserRepository(this.api);

  Future<UserResponseDto> getUser(int id) async {
    final json = await api.getUserById(id);
    return UserResponseDto.fromJson(json);
  }

  Future<List<UserResponseDto>> getAllUsers() async {
    final List<dynamic> jsonList = await api.getAllUsers();
    return jsonList.map((json) => UserResponseDto.fromJson(json)).toList();
  }

  Future<List<UserResponseDto>> getUsersQuery(String? search, int? roleId, int? cityId) async {
    final List<dynamic> jsonList = await api.getUsersQuery(search, roleId, cityId);
    return jsonList.map((json) => UserResponseDto.fromJson(json)).toList();
  }

  Future<String> addUser(RegisterUserDto user) async {
    final json = await api.addUser(user.toJson());
    return json.values.first;
  }

  Future<String> editUser(EditUserDto user, int? userId) async {
    final json = await api.editUser(user.toJson(), userId!);
    return json.values.first;
  }

  Future<String> deleteUser(int? userId) async {
    final json = await api.deleteUser(userId!);
    return json.values.first;
  }

  Future<String> updateUserPassword(UpdateUserPasswordDto updateUserPasswordDto) async {
    final json = await api.updateUserPassword(updateUserPasswordDto);
    return json.values.first;
  }

  Future<String> uploadUserPhoto(File imageFile) async {
    final  image = await api.uploadUserPhoto(imageFile);
    return image;

  }

  Future<String> editUserPhoto(String? photoURL, int? userId) async {
    final json = await api.editUserPhoto(photoURL!, userId!);
    return json;
  }
}