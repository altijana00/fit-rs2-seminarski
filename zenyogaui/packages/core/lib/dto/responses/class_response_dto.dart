
import 'package:json_annotation/json_annotation.dart';


part 'class_response_dto.g.dart';
@JsonSerializable()
class ClassResponseDto {
  final int id;
  final int studioId;
  final int instructorId;
  final int yogaTypeId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int? maxParticipants;
  final String? location;



  ClassResponseDto({
    required this.id,
    required this.studioId,
    required this.instructorId,
    required this.yogaTypeId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    this.maxParticipants,
    this.location

  });

  factory ClassResponseDto.fromJson(Map<String, dynamic> json) => _$ClassResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ClassResponseDtoToJson(this);
}