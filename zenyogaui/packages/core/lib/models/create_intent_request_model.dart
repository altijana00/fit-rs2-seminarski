
import 'package:json_annotation/json_annotation.dart';


part 'create_intent_request_model.g.dart';
@JsonSerializable()
class CreateIntentRequest {
  final int studioId;
  final String currency;

  CreateIntentRequest({
    required this.studioId,
    required this.currency,

  });

  factory CreateIntentRequest.fromJson(Map<String, dynamic> json) => _$CreateIntentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateIntentRequestToJson(this);
}