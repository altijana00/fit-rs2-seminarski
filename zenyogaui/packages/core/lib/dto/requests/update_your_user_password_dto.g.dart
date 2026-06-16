// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_your_user_password_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateYourUserPasswordDto _$UpdateYourUserPasswordDtoFromJson(
  Map<String, dynamic> json,
) => UpdateYourUserPasswordDto(
  oldPassword: json['oldPassword'] as String?,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$UpdateYourUserPasswordDtoToJson(
  UpdateYourUserPasswordDto instance,
) => <String, dynamic>{
  'oldPassword': instance.oldPassword,
  'newPassword': instance.newPassword,
};
