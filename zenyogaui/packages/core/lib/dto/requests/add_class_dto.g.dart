// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_class_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddClassDto _$AddClassDtoFromJson(Map<String, dynamic> json) => AddClassDto(
  yogaTypeId: (json['yogaTypeId'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  location: json['location'] as String?,
);

Map<String, dynamic> _$AddClassDtoToJson(AddClassDto instance) =>
    <String, dynamic>{
      'yogaTypeId': instance.yogaTypeId,
      'name': instance.name,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'location': instance.location,
    };
