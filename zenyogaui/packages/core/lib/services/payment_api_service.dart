import 'package:core/models/create_intent_request_model.dart';
import 'package:dio/dio.dart';

import '../core/constants.dart';

class PaymentApiService {
  final Dio dio;

  PaymentApiService(this.dio);

  Future<bool> isUserPaidMember(int userId, int studioId) async {
    final response = await dio.get(
        'Payment/isUserPaidMember?userId=$userId&studioId=$studioId',
        options: Options(
          validateStatus: (status) => true,
        ));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> addPayment(int userId, int studioId, int amount, String paymentIntentId) async {
    final response = await dio.post(
        'Payment/add?userId=$userId&studioId=$studioId&amount=$amount&paymentIntentId=$paymentIntentId'
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to add studio: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      Map<String, dynamic> createIntentRequest) async {
    final response = await dio.post(
      '${Constants.mobileApiBaseUrl}Payment/create-intent',
      data: createIntentRequest,
    );


    return Map<String, dynamic>.from(response.data);
  }
}