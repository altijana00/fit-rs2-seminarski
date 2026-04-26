// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddNotificationDto _$AddNotificationDtoFromJson(Map<String, dynamic> json) =>
    AddNotificationDto(
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$AddNotificationDtoToJson(AddNotificationDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'type': instance.type,
    };
