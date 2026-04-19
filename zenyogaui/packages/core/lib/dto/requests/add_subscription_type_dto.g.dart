// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_subscription_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddSubscriptionTypeDto _$AddSubscriptionTypeDtoFromJson(
  Map<String, dynamic> json,
) => AddSubscriptionTypeDto(
  name: json['name'] as String,
  description: json['description'] as String?,
  durationInDays: (json['durationInDays'] as num).toInt(),
);

Map<String, dynamic> _$AddSubscriptionTypeDtoToJson(
  AddSubscriptionTypeDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'durationInDays': instance.durationInDays,
};
