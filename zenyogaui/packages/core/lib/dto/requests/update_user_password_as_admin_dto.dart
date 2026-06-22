
import 'package:json_annotation/json_annotation.dart';

part 'update_user_password_as_admin_dto.g.dart';
@JsonSerializable()
class UpdateUserPasswordAsAdminDto {
  final int userId;
  final String newPassword;

  UpdateUserPasswordAsAdminDto({
    required this.userId,
    required this.newPassword,

  });


  Map<String, dynamic> toJson() => _$UpdateUserPasswordAsAdminDtoToJson(this);
}