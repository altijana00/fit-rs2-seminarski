import 'package:core/dto/responses/instructor_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../models/instructor_model.dart';
import '../../repositories/instructor_repository.dart';

class InstructorProvider extends ChangeNotifier {
  final InstructorRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  List<InstructorResponseDto>? _instructors;
  String? _token;

  String? _error;
  Interceptor? _instructorInterceptor;

  InstructorProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  List<InstructorResponseDto>? get instructors => _instructors;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);


    if (token != null && token.isNotEmpty) {
      try {
        _instructors = await repository.getAllInstructors();
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
    if (_instructorInterceptor != null) {
      dio.interceptors.remove(_instructorInterceptor!);
    }

    _instructorInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );

    dio.interceptors.add(_instructorInterceptor!);
  }

}


