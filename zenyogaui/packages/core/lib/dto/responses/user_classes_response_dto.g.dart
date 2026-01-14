// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_classes_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserClassesResponseDto _$UserClassesResponseDtoFromJson(
  Map<String, dynamic> json,
) => UserClassesResponseDto(
  id: (json['id'] as num).toInt(),
  classId: (json['classId'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  studioId: (json['studioId'] as num).toInt(),
  yogaTypeId: (json['yogaTypeId'] as num).toInt(),
  instructorId: (json['instructorId'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  location: json['location'] as String?,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  joinedAt: DateTime.parse(json['joinedAt'] as String),
);

Map<String, dynamic> _$UserClassesResponseDtoToJson(
  UserClassesResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'classId': instance.classId,
  'userId': instance.userId,
  'studioId': instance.studioId,
  'instructorId': instance.instructorId,
  'yogaTypeId': instance.yogaTypeId,
  'name': instance.name,
  'description': instance.description,
  'location': instance.location,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'maxParticipants': instance.maxParticipants,
  'joinedAt': instance.joinedAt.toIso8601String(),
};
