
import 'package:json_annotation/json_annotation.dart';


part 'edit_instructor_dto.g.dart';
@JsonSerializable()
class EditInstructorDto {
  final String firstName;
  final String lastName;
  final String email;
  final String? diplomas;
  final String? certificates;
  final String? biography;

  EditInstructorDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.diplomas,
    this.certificates,
    this.biography,

  });

  factory EditInstructorDto.fromJson(Map<String, dynamic> json) => _$EditInstructorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditInstructorDtoToJson(this);
}