// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_password_as_admin_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserPasswordAsAdminDto _$UpdateUserPasswordAsAdminDtoFromJson(
  Map<String, dynamic> json,
) => UpdateUserPasswordAsAdminDto(
  userId: (json['userId'] as num).toInt(),
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$UpdateUserPasswordAsAdminDtoToJson(
  UpdateUserPasswordAsAdminDto instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'newPassword': instance.newPassword,
};
