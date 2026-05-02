// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants_by_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantsByCity _$ParticipantsByCityFromJson(Map<String, dynamic> json) =>
    ParticipantsByCity(
      cityName: json['cityName'] as String,
      numberOfParticipants: (json['numberOfParticipants'] as num).toInt(),
    );

Map<String, dynamic> _$ParticipantsByCityToJson(ParticipantsByCity instance) =>
    <String, dynamic>{
      'cityName': instance.cityName,
      'numberOfParticipants': instance.numberOfParticipants,
    };
