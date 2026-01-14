

import 'package:json_annotation/json_annotation.dart';


part 'edit_studio_subscription_dto.g.dart';
@JsonSerializable()
class EditStudioSubscriptionDto {
  final double price;
  final String? description;


  EditStudioSubscriptionDto({
    required this.price,
    this.description,
  });

  factory EditStudioSubscriptionDto.fromJson(Map<String, dynamic> json) => _$EditStudioSubscriptionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditStudioSubscriptionDtoToJson(this);
}