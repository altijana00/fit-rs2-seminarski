



import 'package:core/models/create_intent_request_model.dart';

import '../dto/responses/payment_response_dto.dart';
import '../services/payment_api_service.dart';

class PaymentRepository {
  final PaymentApiService api;

  PaymentRepository(this.api);

  Future<bool> isUserPaidMember(int userId, int studioId) async {
    return await api.isUserPaidMember(userId, studioId);
  }

  Future<String> addPayment(int userId, int studioId, int amount, String paymentIntentId) async {
    final json = await api.addPayment(userId, studioId, amount, paymentIntentId);
    return json.values.first;

  }

  Future<Map<String, dynamic>> createPaymentIntent(CreateIntentRequest createIntentRequest) async {
    final json = await api.createPaymentIntent(createIntentRequest.toJson());
    return json;

  }

  Future<List<PaymentResponseDto>> getAllPayments() async {
    final List<dynamic> jsonList = await api.getAllPayments();
    return jsonList.map((json) => PaymentResponseDto.fromJson(json)).toList();
  }

  Future<List<PaymentResponseDto>> getPaymentsQuery(String? search) async {
    final List<dynamic> jsonList = await api.getPaymentsQuery(search);
    return jsonList.map((json) => PaymentResponseDto.fromJson(json)).toList();
  }

  Future<List<PaymentResponseDto>> getUserPayments(int userId) async {
    final List<dynamic> jsonList = await api.getUserPayments(userId);
    return jsonList.map((json) => PaymentResponseDto.fromJson(json)).toList();
  }

  Future<List<PaymentResponseDto>> getStudioPayments(int studioId) async {
    final List<dynamic> jsonList = await api.getStudioPayments(studioId);
    return jsonList.map((json) => PaymentResponseDto.fromJson(json)).toList();
  }

  Future<PaymentResponseDto> getPaymentById(int paymentId) async {
    final json = await api.getPaymentById(paymentId);
    return PaymentResponseDto.fromJson(json);
  }

}