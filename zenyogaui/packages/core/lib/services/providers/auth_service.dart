import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../dto/responses/user_response_dto.dart';
import '../../models/user_login_model.dart';
import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;
  final UserRepository userRepository;

  UserLoginModel? _loginUser;
  UserResponseDto? _user;
  String? _token;
  bool _loading = false;
  String? _error;
  Interceptor? _authInterceptor;
  //UserRepository? _userRepository;

  AuthProvider({
    required this.repository,
    required this.dio,
    required this.storage,
    required this.userRepository
  }) {
    _tryRestoreSession();
  }

  UserLoginModel? get loginUser => _loginUser;
  UserResponseDto? get user => _user;
  bool get isLoading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _loginUser != null;
 // UserRepository get userRepository => _userRepository;
  set user (UserResponseDto userDto) {
    _user = userDto;
    }

  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);
    final userId = await storage.read(key: Constants.userIdStorageKey);

    if (token != null && token.isNotEmpty && userId != null) {
      try {

        _token = token;
        _attachInterceptor(token);

        _user = await userRepository.getUser(int.parse(userId));
        notifyListeners();
      } catch (e) {
        logout();
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

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final loginUser = await repository.login(email, password);
      _loginUser = loginUser;

      _token = loginUser.token;

      _attachInterceptor(_token!);

      await storage.write(key: Constants.jwtStorageKey, value: _token);
      await storage.write(key: Constants.userIdStorageKey, value: loginUser.id);

      _user = await userRepository.getUser(int.parse(loginUser.id));

      _loading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _loading = false;
      _error = e.response?.data;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    if (_authInterceptor != null) {
      dio.interceptors.remove(_authInterceptor!);
      _authInterceptor = null;
    }

    _loginUser = null;
    _user = null;
    _token = null;
    _error = null;

    await storage.delete(key: Constants.jwtStorageKey);
    await storage.delete(key: Constants.userIdStorageKey);
    notifyListeners();
  }
}