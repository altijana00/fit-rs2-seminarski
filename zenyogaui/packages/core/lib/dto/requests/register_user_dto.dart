
import 'package:json_annotation/json_annotation.dart';


part 'register_user_dto.g.dart';
@JsonSerializable()
class RegisterUserDto {
  final String firstName;
  final String lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String email;
  final String password;
  final String? profileImageUrl;
  final int roleId;
  final int cityId;

  RegisterUserDto({
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    required this.email,
    required this.password,
    this.profileImageUrl,
    required this.roleId,
    required this.cityId
  });

  factory RegisterUserDto.fromJson(Map<String, dynamic> json) => _$RegisterUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserDtoToJson(this);
}