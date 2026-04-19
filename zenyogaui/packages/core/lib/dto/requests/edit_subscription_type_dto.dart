
import 'package:json_annotation/json_annotation.dart';


part 'edit_subscription_type_dto.g.dart';
@JsonSerializable()
class EditSubscriptionTypeDto {
  final String name;
  final String? description;
  final int durationInDays;




  EditSubscriptionTypeDto({
    required this.name,
    this.description,
    required this.durationInDays


  });

  factory EditSubscriptionTypeDto.fromJson(Map<String, dynamic> json) => _$EditSubscriptionTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditSubscriptionTypeDtoToJson(this);
}