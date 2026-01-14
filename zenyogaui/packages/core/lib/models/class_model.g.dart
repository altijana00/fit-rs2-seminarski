// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => ClassModel(
  id: (json['id'] as num?)?.toInt(),
  studioId: (json['studioId'] as num?)?.toInt(),
  instructorId: (json['instructorId'] as num?)?.toInt(),
  yogaTypeId: (json['yogaTypeId'] as num?)?.toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  location: json['location'] as String?,
);

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studioId': instance.studioId,
      'instructorId': instance.instructorId,
      'yogaTypeId': instance.yogaTypeId,
      'name': instance.name,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'location': instance.location,
    };
