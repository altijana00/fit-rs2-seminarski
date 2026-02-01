// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_instructor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditInstructorDto _$EditInstructorDtoFromJson(Map<String, dynamic> json) =>
    EditInstructorDto(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      diplomas: json['diplomas'] as String?,
      certificates: json['certificates'] as String?,
      biography: json['biography'] as String?,
    );

Map<String, dynamic> _$EditInstructorDtoToJson(EditInstructorDto instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'diplomas': instance.diplomas,
      'certificates': instance.certificates,
      'biography': instance.biography,
    };
