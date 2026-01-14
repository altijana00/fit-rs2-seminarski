
import 'package:json_annotation/json_annotation.dart';


part 'edit_class_dto.g.dart';
@JsonSerializable()
class EditClassDto {
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int? maxParticipants;
  final String? location;



  EditClassDto({
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    this.maxParticipants,
    this.location

  });

  factory EditClassDto.fromJson(Map<String, dynamic> json) => _$EditClassDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditClassDtoToJson(this);
}