
import 'package:core/dto/requests/edit_notification_dto.dart';
import 'package:core/dto/responses/notification_response_dto.dart';

import '../dto/requests/add_notification_dto.dart';
import '../services/notification_api_service.dart';


class NotificationRepository {
  final NotificationApiService api;

  NotificationRepository(this.api);

  Future<List<NotificationResponseDto>> getAllNotifications() async {
    final List<dynamic> jsonList = await api.getAllNotifications();
    return jsonList.map((json) => NotificationResponseDto.fromJson(json)).toList();
  }

  Future<List<NotificationResponseDto>> getNotificationsQuery(String? search) async {
    final List<dynamic> jsonList = await api.getNotificationsQuery(search);
    return jsonList.map((json) => NotificationResponseDto.fromJson(json)).toList();
  }

  // Future<List<InstructorResponseDto>> getByStudioId(int studioId) async {
  //   final List<dynamic> jsonList = await api.getByStudioId(studioId);
  //   return jsonList.map((json) => InstructorResponseDto.fromJson(json)).toList();
  // }
  //
  // Future<InstructorResponseDto> getById(int id) async {
  //   final json = await api.getById(id);
  //   return InstructorResponseDto.fromJson(json);
  // }
  //
    Future<String> addNotification(AddNotificationDto addNotificationDto) async {
      final json = await api.addNotification(
          addNotificationDto.toJson());
      return json.values.first;
    }

  Future<String> deleteNotification(int notificationId, userId) async {
    final json = await api.deleteNotification(notificationId, userId);
    return json.values.first;
  }

  Future<String> editNotification(EditNotificationDto notification, int notificationId) async {
    final json = await api.editNotification(notification.toJson(), notificationId);
    return json.values.first;
  }

}