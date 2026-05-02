
import 'package:core/dto/responses/class_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participants_by_city.g.dart';
@JsonSerializable()
class ParticipantsByCity {
  final String cityName;
  final int numberOfParticipants;



  ParticipantsByCity({
    required this.cityName,
    required this.numberOfParticipants
  });


  factory ParticipantsByCity.fromJson(Map<String, dynamic> json) => _$ParticipantsByCityFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantsByCityToJson(this);
}