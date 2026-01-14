
import 'package:json_annotation/json_annotation.dart';


part 'instructor_response_dto.g.dart';
@JsonSerializable()
class InstructorResponseDto {
  final int id;
  final String firstName;
  final String lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String email;
  final String? profileImageUrl;
  final int roleId;
  final int cityId;
  final String? diplomas;
  final String? certificates;
  final String? biography;
  final int? studioId;

  InstructorResponseDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    required this.email,
    this.profileImageUrl,
    required this.roleId,
    required this.cityId,
    this.diplomas,
    this.certificates,
    this.biography,
    this.studioId

  });

  factory InstructorResponseDto.fromJson(Map<String, dynamic> json) => _$InstructorResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorResponseDtoToJson(this);
}