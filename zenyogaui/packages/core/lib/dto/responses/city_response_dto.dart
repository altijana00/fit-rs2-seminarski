
import 'package:json_annotation/json_annotation.dart';

part 'city_response_dto.g.dart';
@JsonSerializable()
class CityResponseDto {
  final int id;
  final String name;


  CityResponseDto({
    required this.id,
    required this.name,
  });

  factory CityResponseDto.fromJson(Map<String, dynamic> json) => _$CityResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CityResponseDtoToJson(this);
}