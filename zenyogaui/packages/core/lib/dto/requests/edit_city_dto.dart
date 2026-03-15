
import 'package:json_annotation/json_annotation.dart';


part 'edit_city_dto.g.dart';
@JsonSerializable()
class EditCityDto {
  final String name;




  EditCityDto({
    required this.name,


  });

  factory EditCityDto.fromJson(Map<String, dynamic> json) => _$EditCityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditCityDtoToJson(this);
}