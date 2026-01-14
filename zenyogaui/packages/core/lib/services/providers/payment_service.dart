import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../../repositories/payment_repository.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository repository;
  final Dio dio;
  final FlutterSecureStorage storage;


  String? _token;

  String? _error;
  Interceptor? _paymentInterceptor;

  PaymentProvider({
    required this.repository,
    required this.dio,
    required this.storage,
  }) {
    _tryRestoreSession();
  }



  String? get error => _error;


  Future<void> _tryRestoreSession() async {
    final token = await storage.read(key: Constants.jwtStorageKey);


    if (token != null && token.isNotEmpty) {
      try {
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
    if (_paymentInterceptor != null) {
      dio.interceptors.remove(_paymentInterceptor!);
    }

    _paymentInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    );

    dio.interceptors.add(_paymentInterceptor!);
  }

}


