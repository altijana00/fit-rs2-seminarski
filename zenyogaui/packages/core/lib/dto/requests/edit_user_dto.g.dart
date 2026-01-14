// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditUserDto _$EditUserDtoFromJson(Map<String, dynamic> json) => EditUserDto(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  gender: json['gender'] as String?,
  email: json['email'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
);

Map<String, dynamic> _$EditUserDtoToJson(EditUserDto instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
    };
