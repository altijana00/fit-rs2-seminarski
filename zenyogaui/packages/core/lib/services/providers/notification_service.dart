import 'package:core/dto/responses/notification_response_dto.dart';
import 'package:core/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  List<NotificationResponseDto>? _notifications;
  String? _token;

  String? _error;
  Interceptor? _notificationInterceptor;

  NotificationProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }


  List<NotificationResponseDto>? get notifications => _notifications;

  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);


    if (token != null && token.isNotEmpty) {
      try {
        _notifications = await repository.getAllNotifications();
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
    if (_notificationInterceptor != null) {
      dio.interceptors.remove(_notificationInterceptor!);
    }

    _notificationInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );

    dio.interceptors.add(_notificationInterceptor!);
  }

}


