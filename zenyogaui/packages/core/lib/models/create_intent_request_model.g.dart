// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_intent_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateIntentRequest _$CreateIntentRequestFromJson(Map<String, dynamic> json) =>
    CreateIntentRequest(
      studioId: (json['studioId'] as num).toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$CreateIntentRequestToJson(
  CreateIntentRequest instance,
) => <String, dynamic>{
  'studioId': instance.studioId,
  'currency': instance.currency,
};
