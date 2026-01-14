// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_password_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserPasswordDto _$UpdateUserPasswordDtoFromJson(
  Map<String, dynamic> json,
) => UpdateUserPasswordDto(
  id: (json['id'] as num).toInt(),
  oldPassword: json['oldPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$UpdateUserPasswordDtoToJson(
  UpdateUserPasswordDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'oldPassword': instance.oldPassword,
  'newPassword': instance.newPassword,
};
