



import '../services/payment_api_service.dart';

class PaymentRepository {
  final PaymentApiService api;

  PaymentRepository(this.api);

  Future<bool> isUserPaidMember(int userId, int studioId) async {
    return await api.isUserPaidMember(userId, studioId);
  }

  Future<String> addPayment(int userId, int studioId) async {
    final json = await api.addPayment(userId, studioId);
    return json.values.first;

  }

}