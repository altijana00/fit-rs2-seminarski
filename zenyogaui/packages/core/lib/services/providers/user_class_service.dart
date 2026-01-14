import 'package:core/dto/responses/user_classes_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../dto/responses/user_response_dto.dart';
import '../../repositories/user_class_repository.dart';
import '../../repositories/user_repository.dart';

class UserClassProvider extends ChangeNotifier {
  final UserClassRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  List<UserClassesResponseDto>? _userClasses;
  String? _token;

  String? _error;
  Interceptor? _authInterceptor;

  UserClassProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  List<UserClassesResponseDto>? get userClasses => _userClasses;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);

    if (token != null) {
      try {
        _userClasses = await repository.getAllUserClasses();
        _token = token;
        _attachInterceptor(token);
        notifyListeners();
      } catch (e) {
        // invalid token — ignore
      }
    }
  }

  void _attachInterceptor(String token) {
    // remove old interceptor if exists
    if (_authInterceptor != null) {
      dio.interceptors.remove(_authInterceptor!);
    }

    _authInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );

    dio.interceptors.add(_authInterceptor!);
  }

}


