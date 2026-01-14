// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_instructor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddInstructorDto _$AddInstructorDtoFromJson(Map<String, dynamic> json) =>
    AddInstructorDto(
      diplomas: json['diplomas'] as String?,
      certificates: json['certificates'] as String?,
      biography: json['biography'] as String?,
    );

Map<String, dynamic> _$AddInstructorDtoToJson(AddInstructorDto instance) =>
    <String, dynamic>{
      'diplomas': instance.diplomas,
      'certificates': instance.certificates,
      'biography': instance.biography,
    };
