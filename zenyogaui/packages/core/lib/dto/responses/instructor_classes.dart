
import 'package:core/dto/responses/class_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instructor_classes.g.dart';
@JsonSerializable()
class InstructorClasses {
  final String name;
  final int numberOfClasses;



  InstructorClasses({
    required this.name,
    required this.numberOfClasses
  });


  factory InstructorClasses.fromJson(Map<String, dynamic> json) => _$InstructorClassesFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorClassesToJson(this);
}