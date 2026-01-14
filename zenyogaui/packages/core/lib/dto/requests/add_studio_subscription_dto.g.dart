// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_studio_subscription_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddStudioSubscriptionDto _$AddStudioSubscriptionDtoFromJson(
  Map<String, dynamic> json,
) => AddStudioSubscriptionDto(
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$AddStudioSubscriptionDtoToJson(
  AddStudioSubscriptionDto instance,
) => <String, dynamic>{
  'price': instance.price,
  'description': instance.description,
};
