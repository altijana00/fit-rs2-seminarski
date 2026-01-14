
import 'package:json_annotation/json_annotation.dart';


part 'add_instructor_dto.g.dart';
@JsonSerializable()
class AddInstructorDto {
  final String? diplomas;
  final String? certificates;
  final String? biography;

  AddInstructorDto({
    this.diplomas,
    this.certificates,
    this.biography,
  });

  factory AddInstructorDto.fromJson(Map<String, dynamic> json) => _$AddInstructorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddInstructorDtoToJson(this);
}