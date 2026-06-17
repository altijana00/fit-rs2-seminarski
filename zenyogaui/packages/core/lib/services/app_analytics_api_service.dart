import 'package:dio/dio.dart';

class AppAnalyticsApiService {
  final Dio dio;

  AppAnalyticsApiService(this.dio);

  Future<Map<String, dynamic>> getAppAnalytics() async {
    final response = await dio.get('AppAnalytics/getAppAnalytics');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    }else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    }
    else {
      throw Exception('Falied to fetch analytics: ${response.data}');
    }
  }

  Future<Map<String, dynamic>> getAppAnalyticsForParticipant() async {
    final response = await dio.get('AppAnalytics/getAppAnalyticsForParticipant');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    }else if (response.statusCode == 400) {
      final data = Map<String, dynamic>.from(response.data);

      if (data['message'] is List) {
        final messages = (data['message'] as List)
            .map((e) => e.toString())
            .join('\n');

        throw Exception(messages);
      }

      if (data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      throw (response.data["message"]);
    } else {
      throw Exception('Falied to fetch analytics: ${response.data}');
    }
  }


}