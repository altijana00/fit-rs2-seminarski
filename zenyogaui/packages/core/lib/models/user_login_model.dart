
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../core/jwt_helper.dart';

part 'user_login_model.g.dart';
@JsonSerializable()
class UserLoginModel {
  final String id;
  final String email;
  final String role;
  final String token;

  UserLoginModel({
    required this.id,
    required this.email,
    required this.role,
    required this.token,
  });

  // create from a JWT token (common when backend returns only token)
  factory UserLoginModel.fromToken(String token) {
    final payload = JwtDecoder.decode(token);
    final id = JwtHelper.extractId(payload);
    final email = JwtHelper.extractEmail(payload);
    final role = JwtHelper.extractRole(payload);
    return UserLoginModel(id: id, email: email, role: role, token: token);
  }

  // create from API response when API returns { "token": "..." } or { "access_token": "..." }
  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    final token = (json['token'] ?? json['access_token'] ?? '').toString();
    if (token.isEmpty) {
      throw ArgumentError('No token found in response');
    }
    return UserLoginModel.fromToken(token);
  }
}