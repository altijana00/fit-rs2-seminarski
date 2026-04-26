import 'dart:convert';
import 'package:core/core/constants.dart';
import 'package:core/models/create_intent_request_model.dart';
import 'package:core/services/providers/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;

  final paymentProvider =
  Provider.of<PaymentProvider>(
    navigatorKey.currentContext!,
    listen: false,
  );


  static const String _publishableKey = Constants.stripeKey;

  Future<void> makePayment({
    required int amount,
    required String currency,
  }) async {
    try {
      final createIntentRequest = CreateIntentRequest(amount: amount, currency: currency);
      paymentIntentData = await createPaymentIntent(createIntentRequest);

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

        await displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception: $e $s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Verify status na backendu


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