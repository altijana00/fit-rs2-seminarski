import 'package:dio/dio.dart';

class NotificationApiService {
  final Dio dio;

  NotificationApiService(this.dio);

  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    final response = await dio.get('Notification/getAll');
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Failed to fetch notifications: ${response.data}');
    }
  }

  Future<List<Map<String, dynamic>>> getNotificationsQuery(String? search) async {
    final response = await dio.get('Notification/getNotificationsQuery',
      queryParameters: {
        if(search != null) 'search': search,
      },
    );
    if(response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Falied to fetch notifications: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> deleteNotification(int notificationId, int userId) async {
    final response = await dio.delete(
        'Notification/delete?id=$notificationId&userId=$userId',
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    }  else if (response.statusCode == 500) {
      var resp = Map<String, dynamic>.from(response.data);
      throw Exception(resp["error"]);
    } else if (response.statusCode == 400) {
      throw (response.data["message"]);
    } else{
      throw Exception('Failed to delete notification: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> editNotification(Map<String, dynamic> notificationData, int notificationId) async {
    final response = await dio.put(
        'Notification/edit?id=$notificationId',
        data: notificationData,
        options: Options(
          validateStatus: (status) => true,
        )
    );

    if (response.statusCode == 200 || response.statusCode == 201){
      return response.data;

    } else if (response.statusCode == 500) {
      var resp = response.data;
      throw Exception(resp["error"]);

    } else{
      throw Exception('Failed to edit notification: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> addNotification(Map<String, dynamic> notificationData) async {
    final response = await dio.post(
      'Notification/add',
      data: notificationData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(response.data);
    } else if (response.statusCode == 400) {
      var resp = Map<String, dynamic>.from(response.data);
      throw Exception(resp["error"]);

    } else {
      throw Exception('Failed to add notification: ${response.data}');
    }
  }
}