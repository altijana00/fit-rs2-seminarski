
import 'package:json_annotation/json_annotation.dart';

part 'update_your_user_password_dto.g.dart';
@JsonSerializable()
class UpdateYourUserPasswordDto {
  final String? oldPassword;
  final String newPassword;

  UpdateYourUserPasswordDto({
    required this.oldPassword,
    required this.newPassword,

  });


  Map<String, dynamic> toJson() => _$UpdateYourUserPasswordDtoToJson(this);
}