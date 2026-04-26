
import 'package:json_annotation/json_annotation.dart';


part 'edit_notification_dto.g.dart';
@JsonSerializable()
class EditNotificationDto {
  final String title;
  final String? content;
  final String type;



  EditNotificationDto({
    required this.title,
    this.content,
    required this.type,

  });

  factory EditNotificationDto.fromJson(Map<String, dynamic> json) => _$EditNotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditNotificationDtoToJson(this);
}