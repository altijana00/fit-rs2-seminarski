

import 'package:json_annotation/json_annotation.dart';


part 'subscription_type_response_dto.g.dart';
@JsonSerializable()
class SubscriptionTypeResponseDto {
  final int id;
  final String name;
  final String? description;
  final int durationInDays;


  SubscriptionTypeResponseDto({
    required this.id,
    required this.name,
    this.description,
    required this.durationInDays
  });

  factory SubscriptionTypeResponseDto.fromJson(Map<String, dynamic> json) => _$SubscriptionTypeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionTypeResponseDtoToJson(this);
}