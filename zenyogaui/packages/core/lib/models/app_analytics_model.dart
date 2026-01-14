
import 'package:json_annotation/json_annotation.dart';



part 'app_analytics_model.g.dart';
@JsonSerializable()
class AppAnalyticsModel {
  final int id;
  final int? totalUsers;
  final int? totalStudios;
  final String? mostPopularCity;

  AppAnalyticsModel({
    required this.id,
    this.totalUsers,
    this.totalStudios,
    this.mostPopularCity

  });

  factory AppAnalyticsModel.fromJson(Map<String, dynamic> json) => _$AppAnalyticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppAnalyticsModelToJson(this);
}