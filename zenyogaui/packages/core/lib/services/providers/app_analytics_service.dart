import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../models/app_analytics_model.dart';
import '../../repositories/app_analytics_repository.dart';


class AppAnalyticsProvider extends ChangeNotifier {
  final AppAnalyticsRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  AppAnalyticsModel? _appAnalytics;
  String? _token;

  String? _error;
  Interceptor? _cityInterceptor;

  AppAnalyticsProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  AppAnalyticsModel? get appAnalytics => _appAnalytics;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);


    if (token != null && token.isNotEmpty) {
      try {
        _appAnalytics = await repository.getAppAnalytics();
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


