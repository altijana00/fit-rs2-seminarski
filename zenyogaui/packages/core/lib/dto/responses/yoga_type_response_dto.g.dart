// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yoga_type_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YogaTypeResponseDto _$YogaTypeResponseDtoFromJson(Map<String, dynamic> json) =>
    YogaTypeResponseDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$YogaTypeResponseDtoToJson(
  YogaTypeResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
};
