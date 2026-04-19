// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_role_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddRoleDto _$AddRoleDtoFromJson(Map<String, dynamic> json) => AddRoleDto(
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$AddRoleDtoToJson(AddRoleDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
