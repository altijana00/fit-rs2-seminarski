import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../models/instructor_model.dart';
import '../../models/role_model.dart';
import '../../repositories/instructor_repository.dart';
import '../../repositories/role_repository.dart';

class RoleProvider extends ChangeNotifier {
  final RoleRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  List<RoleModel>? _roles;
  String? _token;

  String? _error;
  Interceptor? _roleInterceptor;

  RoleProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  List<RoleModel>? get roles => _roles;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);


    if (token != null && token.isNotEmpty) {
      try {
        _token = token;
        _attachInterceptor(token);
        _roles = await repository.getAllRoles();
        notifyListeners();
      } catch (e) {
        // invalid token — ignore
      }
    }
  }

  void _attachInterceptor(String token) {
    // remove old interceptor if exists
    if (_roleInterceptor != null) {
      dio.interceptors.remove(_roleInterceptor!);
    }

    _roleInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );

    dio.interceptors.add(_roleInterceptor!);
  }

}


