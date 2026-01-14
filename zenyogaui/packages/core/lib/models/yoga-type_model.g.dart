// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yoga-type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YogaTypeModel _$YogaTypeModelFromJson(Map<String, dynamic> json) =>
    YogaTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$YogaTypeModelToJson(YogaTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
