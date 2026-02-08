import 'package:core/dto/responses/city_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../models/city_model.dart';
import '../../models/instructor_model.dart';
import '../../repositories/city_repository.dart';
import '../../repositories/instructor_repository.dart';

class CityProvider extends ChangeNotifier {
  final CityRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  List<CityModel>? _cities;
  String? _token;

  String? _error;
  Interceptor? _cityInterceptor;

  CityProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  List<CityModel>? get cities => _cities;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);


    if (token != null && token.isNotEmpty) {
      try {
        _token = token;
        _attachInterceptor(token);
        _cities = await repository.getAllCities();
        notifyListeners();
      } catch (e) {
        // invalid token — ignore
      }
    }
  }

  void _attachInterceptor(String token) {
    // remove old interceptor if exists
    if (_cityInterceptor != null) {
      dio.interceptors.remove(_cityInterceptor!);
    }

    _cityInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );

    dio.interceptors.add(_cityInterceptor!);
  }

}


