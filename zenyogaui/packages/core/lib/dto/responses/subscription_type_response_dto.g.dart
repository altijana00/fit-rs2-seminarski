// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_type_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionTypeResponseDto _$SubscriptionTypeResponseDtoFromJson(
  Map<String, dynamic> json,
) => SubscriptionTypeResponseDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  durationInDays: (json['durationInDays'] as num).toInt(),
);

Map<String, dynamic> _$SubscriptionTypeResponseDtoToJson(
  SubscriptionTypeResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'durationInDays': instance.durationInDays,
};
