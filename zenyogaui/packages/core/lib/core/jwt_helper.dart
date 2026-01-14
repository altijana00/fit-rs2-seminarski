import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  static Map<String, dynamic> decode(String token) {
    return JwtDecoder.decode(token);
  }

  // extract role robustly (handles common claim names)
  static String extractRole(Map<String, dynamic> payload) {
    if (payload.containsKey('role')) {
      final r = payload['role'];
      return r is List ? r.first.toString() : r.toString();
    }
    if (payload.containsKey('roles')) {
      final r = payload['roles'];
      return r is List ? r.first.toString() : r.toString();
    }
    // common .NET claim name
    final dotNetRoleKey = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role';
    if (payload.containsKey(dotNetRoleKey)) {
      final r = payload[dotNetRoleKey];
      return r is List ? r.first.toString() : r.toString();
    }
    return '';
  }

  static String extractId(Map<String, dynamic> payload) {
    return (payload['sub'] ?? payload['id'] ?? payload['nameid'] ?? '').toString();
  }

  static String extractEmail(Map<String, dynamic> payload) {
    return (payload['email'] ?? payload['upn'] ?? '').toString();
  }
}
