// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityResponseDto _$CityResponseDtoFromJson(Map<String, dynamic> json) =>
    CityResponseDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CityResponseDtoToJson(CityResponseDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
