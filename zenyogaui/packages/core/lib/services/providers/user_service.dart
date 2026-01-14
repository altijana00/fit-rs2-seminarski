import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../dto/responses/user_response_dto.dart';
import '../../repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  UserResponseDto? _user;
  String? _token;

  String? _error;
  Interceptor? _authInterceptor;

  UserProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  UserResponseDto? get user => _user;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);
    final userId = await storage.read(key: Constants.userIdStorageKey);

    if (token != null && token.isNotEmpty && userId != null) {
      try {
        _user = await repository.getUser(int.parse(userId));
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


