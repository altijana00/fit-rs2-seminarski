// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleResponseDto _$RoleResponseDtoFromJson(Map<String, dynamic> json) =>
    RoleResponseDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RoleResponseDtoToJson(RoleResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
