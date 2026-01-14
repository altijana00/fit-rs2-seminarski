
import 'package:json_annotation/json_annotation.dart';


part 'edit_user_dto.g.dart';
@JsonSerializable()
class EditUserDto {
  final String firstName;
  final String lastName;
  final String? gender;
  final String email;
  final String? profileImageUrl;


  EditUserDto({
    required this.firstName,
    required this.lastName,
    this.gender,
    required this.email,
    this.profileImageUrl,
  });

  factory EditUserDto.fromJson(Map<String, dynamic> json) => _$EditUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditUserDtoToJson(this);
}