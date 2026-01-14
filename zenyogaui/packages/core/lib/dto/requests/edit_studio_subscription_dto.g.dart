// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_studio_subscription_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditStudioSubscriptionDto _$EditStudioSubscriptionDtoFromJson(
  Map<String, dynamic> json,
) => EditStudioSubscriptionDto(
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$EditStudioSubscriptionDtoToJson(
  EditStudioSubscriptionDto instance,
) => <String, dynamic>{
  'price': instance.price,
  'description': instance.description,
};
