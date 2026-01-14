
import 'package:json_annotation/json_annotation.dart';


part 'instructor_model.g.dart';
@JsonSerializable()
class InstructorModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String email;
  final String? profileImageUrl;
  final int? roleId;
  final int? cityId;
  final String? diplomas;
  final String? certificates;
  final String? biography;
  final int? studioId;

  InstructorModel({
     this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    required this.email,
    this.profileImageUrl,
    this.roleId,
    this.cityId,
    this.diplomas,
    this.certificates,
    this.biography,
    this.studioId

  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) => _$InstructorModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorModelToJson(this);
}