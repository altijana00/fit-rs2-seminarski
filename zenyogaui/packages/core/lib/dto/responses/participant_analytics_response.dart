
import 'package:json_annotation/json_annotation.dart';



part 'participant_analytics_response.g.dart';
@JsonSerializable()
class ParticipantAnalyticsResponse {
  final int? numberOfClasses;
  final int? numberOfStudios;


  ParticipantAnalyticsResponse({
    this.numberOfClasses,
    this.numberOfStudios

  });

  factory ParticipantAnalyticsResponse.fromJson(Map<String, dynamic> json) => _$ParticipantAnalyticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantAnalyticsResponseToJson(this);
}