
import 'package:json_annotation/json_annotation.dart';


part 'class_model.g.dart';
@JsonSerializable()
class ClassModel {
  final int? id;
  final int? studioId;
  final int? instructorId;
  final int? yogaTypeId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int? maxParticipants;
  final String? location;



  ClassModel({
     this.id,
     this.studioId,
     this.instructorId,
     this.yogaTypeId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    this.maxParticipants,
    this.location

  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => _$ClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
}