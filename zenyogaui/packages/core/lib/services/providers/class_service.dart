import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../dto/responses/class_response_dto.dart';
import '../../models/class_model.dart';
import '../../repositories/class_repository.dart';

class ClassProvider extends ChangeNotifier {
  final ClassRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  List<ClassResponseDto>? _classes;
  String? _token;

  String? _error;
  Interceptor? _classInterceptor;

  ClassProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  List<ClassResponseDto>? get classes => _classes;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);
    final instructorId = await storage.read(key: Constants.userIdStorageKey);

    if (token != null && token.isNotEmpty && instructorId != null) {
      try {
        _classes = await repository.getByInstructorId(int.parse(instructorId));
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
    if (_classInterceptor != null) {
      dio.interceptors.remove(_classInterceptor!);
    }

    _classInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );

    dio.interceptors.add(_classInterceptor!);
  }

}


