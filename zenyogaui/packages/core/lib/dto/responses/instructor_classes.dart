
import 'package:core/dto/responses/class_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instructor_classes.g.dart';
@JsonSerializable()
class InstructorClasses {
  final String firstName;
  final String lastName;
  final int numberOfClasses;



  InstructorClasses({
    required this.firstName,
    required this.lastName,
    required this.numberOfClasses
  });


  factory InstructorClasses.fromJson(Map<String, dynamic> json) => _$InstructorClassesFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorClassesToJson(this);
}