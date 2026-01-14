
import '../models/app_analytics_model.dart';
import '../services/app_analytics_api_service.dart';



class AppAnalyticsRepository {
  final AppAnalyticsApiService api;

  AppAnalyticsRepository(this.api);

  Future<AppAnalyticsModel> getAppAnalytics() async {
    final json = await api.getAppAnalytics();
    return AppAnalyticsModel.fromJson(json);
  }



}