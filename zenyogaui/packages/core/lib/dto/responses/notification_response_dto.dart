
import 'package:json_annotation/json_annotation.dart';


part 'notification_response_dto.g.dart';
@JsonSerializable()
class NotificationResponseDto {
  final int id;
  final int userId;
  final String title;
  final String? content;
  final String type;
  final bool isRead;
  final DateTime createdAt;


  NotificationResponseDto({
    required this.id,
    required this.userId,
    required this.title,
    this.content,
    required this.type,
    required this.isRead,
    required this.createdAt,


  });

  factory NotificationResponseDto.fromJson(Map<String, dynamic> json) => _$NotificationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseDtoToJson(this);
}