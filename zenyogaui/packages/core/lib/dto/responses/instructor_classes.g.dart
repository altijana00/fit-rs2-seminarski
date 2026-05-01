// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorClasses _$InstructorClassesFromJson(Map<String, dynamic> json) =>
    InstructorClasses(
      name: json['name'] as String,
      numberOfClasses: (json['numberOfClasses'] as num).toInt(),
    );

Map<String, dynamic> _$InstructorClassesToJson(InstructorClasses instance) =>
    <String, dynamic>{
      'name': instance.name,
      'numberOfClasses': instance.numberOfClasses,
    };
