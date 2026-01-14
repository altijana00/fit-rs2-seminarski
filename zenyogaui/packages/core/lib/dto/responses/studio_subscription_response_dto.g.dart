// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_subscription_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudioSubscriptionResponseDto _$StudioSubscriptionResponseDtoFromJson(
  Map<String, dynamic> json,
) => StudioSubscriptionResponseDto(
  id: (json['id'] as num).toInt(),
  studioId: (json['studioId'] as num).toInt(),
  subscriptionTypeId: (json['subscriptionTypeId'] as num).toInt(),
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String?,
  durationInDays: (json['durationInDays'] as num).toInt(),
);

Map<String, dynamic> _$StudioSubscriptionResponseDtoToJson(
  StudioSubscriptionResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'studioId': instance.studioId,
  'subscriptionTypeId': instance.subscriptionTypeId,
  'name': instance.name,
  'price': instance.price,
  'description': instance.description,
  'durationInDays': instance.durationInDays,
};
