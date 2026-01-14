

import 'package:json_annotation/json_annotation.dart';


part 'add_studio_subscription_dto.g.dart';
@JsonSerializable()
class AddStudioSubscriptionDto {
  final double price;
  final String? description;


  AddStudioSubscriptionDto({
    required this.price,
    this.description,
  });

  factory AddStudioSubscriptionDto.fromJson(Map<String, dynamic> json) => _$AddStudioSubscriptionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddStudioSubscriptionDtoToJson(this);
}