
import 'package:json_annotation/json_annotation.dart';

part 'update_user_password_dto.g.dart';
@JsonSerializable()
class UpdateUserPasswordDto {
  final int id;
  final String oldPassword;
  final String newPassword;

  UpdateUserPasswordDto({
    required this.id,
    required this.oldPassword,
    required this.newPassword,

  });


  Map<String, dynamic> toJson() => _$UpdateUserPasswordDtoToJson(this);
}