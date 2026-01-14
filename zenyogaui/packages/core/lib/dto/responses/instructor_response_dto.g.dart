// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorResponseDto _$InstructorResponseDtoFromJson(
  Map<String, dynamic> json,
) => InstructorResponseDto(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  gender: json['gender'] as String?,
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  email: json['email'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  roleId: (json['roleId'] as num).toInt(),
  cityId: (json['cityId'] as num).toInt(),
  diplomas: json['diplomas'] as String?,
  certificates: json['certificates'] as String?,
  biography: json['biography'] as String?,
  studioId: (json['studioId'] as num?)?.toInt(),
);

Map<String, dynamic> _$InstructorResponseDtoToJson(
  InstructorResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'gender': instance.gender,
  'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
  'email': instance.email,
  'profileImageUrl': instance.profileImageUrl,
  'roleId': instance.roleId,
  'cityId': instance.cityId,
  'diplomas': instance.diplomas,
  'certificates': instance.certificates,
  'biography': instance.biography,
  'studioId': instance.studioId,
};
