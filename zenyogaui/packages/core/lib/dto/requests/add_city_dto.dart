
import 'package:json_annotation/json_annotation.dart';


part 'add_city_dto.g.dart';
@JsonSerializable()
class AddCityDto {
  final String name;




  AddCityDto({
    required this.name,


  });

  factory AddCityDto.fromJson(Map<String, dynamic> json) => _$AddCityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddCityDtoToJson(this);
}