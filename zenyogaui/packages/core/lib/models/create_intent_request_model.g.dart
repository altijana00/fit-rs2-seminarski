// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_intent_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateIntentRequest _$CreateIntentRequestFromJson(Map<String, dynamic> json) =>
    CreateIntentRequest(
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$CreateIntentRequestToJson(
  CreateIntentRequest instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'currency': instance.currency,
};
