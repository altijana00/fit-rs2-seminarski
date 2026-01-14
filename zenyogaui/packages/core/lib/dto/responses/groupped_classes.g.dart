// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupped_classes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrouppedClasses _$GrouppedClassesFromJson(Map<String, dynamic> json) =>
    GrouppedClasses(
      hathaYoga: (json['hathaYoga'] as List<dynamic>)
          .map((e) => ClassResponseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      yinYoga: (json['yinYoga'] as List<dynamic>)
          .map((e) => ClassResponseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      vinyasaYoga: (json['vinyasaYoga'] as List<dynamic>)
          .map((e) => ClassResponseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GrouppedClassesToJson(GrouppedClasses instance) =>
    <String, dynamic>{
      'hathaYoga': instance.hathaYoga,
      'yinYoga': instance.yinYoga,
      'vinyasaYoga': instance.vinyasaYoga,
    };
