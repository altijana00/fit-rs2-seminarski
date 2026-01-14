import 'package:dio/dio.dart';

class PaymentApiService {
  final Dio dio;

  PaymentApiService(this.dio);

  Future<bool> isUserPaidMember(int userId, int studioId) async {
    final response = await dio.get('Payment/isUserPaidMember?userId=$userId&studioId=$studioId');
    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> addPayment(int userId, int studioId) async {
    final response = await dio.post(
      'Payment/add?userId=$userId&studioId=$studioId'
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to add studio: ${response.data}');
    }
  }


}