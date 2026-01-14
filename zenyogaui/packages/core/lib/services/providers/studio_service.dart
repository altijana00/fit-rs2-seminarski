import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../dto/responses/studio_response_dto.dart';
import '../../models/studio_model.dart';
import '../../repositories/studio_repository.dart';

class StudioProvider extends ChangeNotifier {
  final StudioRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  List<StudioResponseDto>? _studios;
  String? _token;

  String? _error;
  Interceptor? _authInterceptor;

  StudioProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  List<StudioResponseDto>? get studios => _studios;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);
    final ownerId = await storage.read(key: Constants.userIdStorageKey);

    if (token != null && token.isNotEmpty && ownerId != null) {
      try {
        _studios = await repository.getStudioByOwner(int.parse(ownerId));
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


