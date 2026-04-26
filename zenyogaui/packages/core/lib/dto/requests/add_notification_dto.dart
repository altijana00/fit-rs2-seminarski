
import 'package:json_annotation/json_annotation.dart';


part 'add_notification_dto.g.dart';
@JsonSerializable()
class AddNotificationDto {
  final int userId;
  final String title;
  final String? content;
  final String type;


  AddNotificationDto({
    required this.userId,
    required this.title,
    this.content,
    required this.type,



  });

  factory AddNotificationDto.fromJson(Map<String, dynamic> json) => _$AddNotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddNotificationDtoToJson(this);
}