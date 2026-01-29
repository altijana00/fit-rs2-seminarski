// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_studio_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditStudioDto _$EditStudioDtoFromJson(Map<String, dynamic> json) =>
    EditStudioDto(
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
    );

Map<String, dynamic> _$EditStudioDtoToJson(EditStudioDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
    };
