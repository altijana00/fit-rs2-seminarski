
import 'package:json_annotation/json_annotation.dart';


part 'user_model.g.dart';
@JsonSerializable()
class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String email;
  final String? profileImageUrl;
  final int roleId;
  final int cityId;

  UserModel({
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

 factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}