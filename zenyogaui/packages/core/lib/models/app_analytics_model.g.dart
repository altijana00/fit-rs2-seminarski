// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppAnalyticsModel _$AppAnalyticsModelFromJson(Map<String, dynamic> json) =>
    AppAnalyticsModel(
      id: (json['id'] as num).toInt(),
      totalUsers: (json['totalUsers'] as num?)?.toInt(),
      totalStudios: (json['totalStudios'] as num?)?.toInt(),
      mostPopularCity: json['mostPopularCity'] as String?,
    );

Map<String, dynamic> _$AppAnalyticsModelToJson(AppAnalyticsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalUsers': instance.totalUsers,
      'totalStudios': instance.totalStudios,
      'mostPopularCity': instance.mostPopularCity,
    };
