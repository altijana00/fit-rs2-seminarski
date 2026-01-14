

import 'package:json_annotation/json_annotation.dart';


part 'studio_subscription_response_dto.g.dart';
@JsonSerializable()
class StudioSubscriptionResponseDto {
  final int id;
  final int studioId;
  final int subscriptionTypeId;
  final String name;
  final double price;
  final String? description;
  final int durationInDays;


  StudioSubscriptionResponseDto({
    required this.id,
    required this.studioId,
    required this.subscriptionTypeId,
    required this.name,
    required this.price,
    this.description,
    required this.durationInDays
  });

  factory StudioSubscriptionResponseDto.fromJson(Map<String, dynamic> json) => _$StudioSubscriptionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StudioSubscriptionResponseDtoToJson(this);
}