import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../core/paging_defaults.dart';
import '../../dto/responses/paged_response.dart';
import '../../dto/responses/yoga_type_response_dto.dart';
import '../../repositories/yoga-type_repository.dart';

class YogaTypeProvider extends ChangeNotifier {
  final YogaTypeRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  PagedResponse<YogaTypeResponseDto>? _yogaTypes;
  String? _token;

  String? _error;
  Interceptor? _yogaTypeInterceptor;

  YogaTypeProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  PagedResponse<YogaTypeResponseDto>? get yogaTypes => _yogaTypes;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);


    if (token != null && token.isNotEmpty) {
      try {
        _yogaTypes = await repository.getAllYogaTypes(page: PagingDefaults.firstPage,
          pageSize: PagingDefaults.pageSize,);
        _token = token;
        _attachInterceptor(token);
        notifyListeners();
      } catch (e) {
        // invalid token — ignore
      }
    }
  }

  void _attachInterceptor(String token) {
    if (_yogaTypeInterceptor != null) {
      dio.interceptors.remove(_yogaTypeInterceptor!);
    }

    _yogaTypeInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );

    dio.interceptors.add(_yogaTypeInterceptor!);
  }

}


