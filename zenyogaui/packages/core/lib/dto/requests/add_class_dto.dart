
import 'package:json_annotation/json_annotation.dart';


part 'add_class_dto.g.dart';
@JsonSerializable()
class AddClassDto {
  final int yogaTypeId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int? maxParticipants;
  final String? location;



  AddClassDto({
    required this.yogaTypeId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    this.maxParticipants,
    this.location

  });

  factory AddClassDto.fromJson(Map<String, dynamic> json) => _$AddClassDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddClassDtoToJson(this);
}