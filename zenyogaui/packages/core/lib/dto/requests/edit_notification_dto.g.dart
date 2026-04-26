// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditNotificationDto _$EditNotificationDtoFromJson(Map<String, dynamic> json) =>
    EditNotificationDto(
      title: json['title'] as String,
      content: json['content'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$EditNotificationDtoToJson(
  EditNotificationDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'content': instance.content,
  'type': instance.type,
};
