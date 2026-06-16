import 'package:core/models/create_intent_request_model.dart';
import 'package:dio/dio.dart';

import '../core/app_config.dart';
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

  Future<Map<String, dynamic>> addPayment(int studioId, int amount, String paymentIntentId) async {
    final response = await dio.post(
        'Payment/add?&studioId=$studioId&amount=$amount&paymentIntentId=$paymentIntentId'
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
      '${AppConfig.mobileApiBaseUrl}Payment/create-intent',
      data: createIntentRequest,
    );


    return Map<String, dynamic>.from(response.data);
  }

  Future<List<Map<String, dynamic>>> getAllPayments() async {
    final response = await dio.get('Payment/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch payments: ${response.data}');
    }
  }

  Future<double> getPaymentsTotal() async {
    final response = await dio.get('Payment/getPaymentsTotal');
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Falied to fetch payments: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getPaymentsQuery(String? search) async {
    final response = await dio.get('Payment/getPaymentsQuery',
      queryParameters: {
        if(search != null) 'search': search,
      },
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch payments: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> getPaymentById(int paymentId) async {
    final response = await dio.get('Payment/getById?paymentId=$paymentId');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch payment: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserPayments(int userId) async {
    final response = await dio.get('Payment/getUserPayment?userId=$userId');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch user payments: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getStudioPayments(int studioId) async {
    final response = await dio.get('Payment/getStudioPayment?studioId=$studioId');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch studio payments: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getPaymentsOfOwnerStudios(int ownerId) async {
    final response = await dio.get('Payment/getPaymentsOfOwnerStudios?ownerId=$ownerId');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch studio payments: ${response.data}');
    }
  }
}

