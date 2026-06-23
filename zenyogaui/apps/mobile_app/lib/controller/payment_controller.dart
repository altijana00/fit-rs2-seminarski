
import 'package:core/models/create_intent_request_model.dart';
import 'package:core/services/providers/payment_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;


  final paymentProvider =
  Provider.of<PaymentProvider>(
    navigatorKey.currentContext!,
    listen: false,
  );

  final studioProvider =
  Provider.of<PaymentProvider>(
    navigatorKey.currentContext!,
    listen: false,
  );



  Future<void> makePayment({
    required String currency,
    required int userId,
    required int studioId
  }) async {
    try {
      final createIntentRequest = CreateIntentRequest(studioId: studioId, currency: currency);
      paymentIntentData = await createPaymentIntent(createIntentRequest);

      final paymentIntentId = paymentIntentData!['client_secret'].split('_secret_')[0];
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            merchantDisplayName: 'Prospects',
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            customerId: paymentIntentData!['customer'],
            customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
            googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              testEnv: true,
            ),
          ),
        );

       await displayPaymentSheet(studioId, paymentIntentData!['amount'], paymentIntentId);
      }
    } catch (e, s) {
      print('exception: $e $s');
    }
  }

  Future<void> displayPaymentSheet(int studioId, int amount, String paymentIntentId) async {
    try {
      await Stripe.instance.presentPaymentSheet();


      await paymentProvider.repository.addPayment(studioId,amount,paymentIntentId);



    } on StripeException catch (e) {
      print('Stripe error: ${e.error.localizedMessage}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }


  Future<Map<String, dynamic>?> createPaymentIntent(
      CreateIntentRequest createIntentRequest
      ) async {
    try {
      final response = await paymentProvider.repository.createPaymentIntent(createIntentRequest);


      return response;
    } catch (e) {
      print('Error calling backend: $e');
      return null;
    }
  }
}