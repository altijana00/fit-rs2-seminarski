// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_subscription_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditSubscriptionTypeDto _$EditSubscriptionTypeDtoFromJson(
  Map<String, dynamic> json,
) => EditSubscriptionTypeDto(
  name: json['name'] as String,
  description: json['description'] as String?,
  durationInDays: (json['durationInDays'] as num).toInt(),
);

Map<String, dynamic> _$EditSubscriptionTypeDtoToJson(
  EditSubscriptionTypeDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'durationInDays': instance.durationInDays,
};
