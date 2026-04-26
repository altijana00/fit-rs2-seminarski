
import 'package:json_annotation/json_annotation.dart';


part 'create_intent_request_model.g.dart';
@JsonSerializable()
class CreateIntentRequest {
  final int amount;
  final String currency;

  CreateIntentRequest({
    required this.amount,
    required this.currency,

  });

  factory CreateIntentRequest.fromJson(Map<String, dynamic> json) => _$CreateIntentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateIntentRequestToJson(this);
}