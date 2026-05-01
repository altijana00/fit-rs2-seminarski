// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorClasses _$InstructorClassesFromJson(Map<String, dynamic> json) =>
    InstructorClasses(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      numberOfClasses: (json['numberOfClasses'] as num).toInt(),
    );

Map<String, dynamic> _$InstructorClassesToJson(InstructorClasses instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'numberOfClasses': instance.numberOfClasses,
    };
