import 'package:dio/dio.dart';

class AppAnalyticsApiService {
  final Dio dio;

  AppAnalyticsApiService(this.dio);

  Future<Map<String, dynamic>> getAppAnalytics() async {
    final response = await dio.get('AppAnalytics/getAppAnalytics');
    if(response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Falied to fetch analytics: ${response.data}');
    }
  }


}