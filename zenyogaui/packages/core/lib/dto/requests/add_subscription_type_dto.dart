
import 'package:json_annotation/json_annotation.dart';


part 'add_subscription_type_dto.g.dart';
@JsonSerializable()
class AddSubscriptionTypeDto {
  final String name;
  final String? description;
  final int durationInDays;




  AddSubscriptionTypeDto({
    required this.name,
    this.description,
    required this.durationInDays


  });

  factory AddSubscriptionTypeDto.fromJson(Map<String, dynamic> json) => _$AddSubscriptionTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddSubscriptionTypeDtoToJson(this);
}