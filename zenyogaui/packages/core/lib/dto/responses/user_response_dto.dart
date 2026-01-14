
import 'package:json_annotation/json_annotation.dart';


part 'user_response_dto.g.dart';
@JsonSerializable()
class UserResponseDto {
  final int id;
  final String firstName;
  final String lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String email;
  final String? profileImageUrl;
  final int roleId;
  final int cityId;

  UserResponseDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    required this.email,
    this.profileImageUrl,
    required this.roleId,
    required this.cityId
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) => _$UserResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseDtoToJson(this);
}