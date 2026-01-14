

import 'package:json_annotation/json_annotation.dart';



part 'user_classes_response_dto.g.dart';
@JsonSerializable()
class UserClassesResponseDto {
  final int id;
  final int classId;
  final int userId;
  final int studioId;
  final int instructorId;
  final int yogaTypeId;
  final String name;
  final String? description;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;
  final int? maxParticipants;
  final DateTime joinedAt;


  UserClassesResponseDto({
    required this.id,
    required this.classId,
    required this.userId,
    required this.studioId,
    required this.yogaTypeId,
    required this.instructorId,
    required this.name,
    this.description,
    this.location,
    required this.startDate,
    required this.endDate,
    this.maxParticipants,
    required this.joinedAt

  });

  factory UserClassesResponseDto.fromJson(Map<String, dynamic> json) => _$UserClassesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserClassesResponseDtoToJson(this);
}