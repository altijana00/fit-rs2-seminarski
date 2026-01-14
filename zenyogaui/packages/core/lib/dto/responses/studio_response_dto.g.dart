// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studio_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudioResponseDto _$StudioResponseDtoFromJson(Map<String, dynamic> json) =>
    StudioResponseDto(
      id: (json['id'] as num).toInt(),
      ownerId: (json['ownerId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      cityId: (json['cityId'] as num).toInt(),
    );

Map<String, dynamic> _$StudioResponseDtoToJson(StudioResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'profileImageUrl': instance.profileImageUrl,
      'cityId': instance.cityId,
    };
