// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_analytics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantAnalyticsResponse _$ParticipantAnalyticsResponseFromJson(
  Map<String, dynamic> json,
) => ParticipantAnalyticsResponse(
  numberOfClasses: (json['numberOfClasses'] as num?)?.toInt(),
  numberOfStudios: (json['numberOfStudios'] as num?)?.toInt(),
);

Map<String, dynamic> _$ParticipantAnalyticsResponseToJson(
  ParticipantAnalyticsResponse instance,
) => <String, dynamic>{
  'numberOfClasses': instance.numberOfClasses,
  'numberOfStudios': instance.numberOfStudios,
};
