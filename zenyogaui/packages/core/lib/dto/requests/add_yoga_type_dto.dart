
import 'package:json_annotation/json_annotation.dart';


part 'add_yoga_type_dto.g.dart';
@JsonSerializable()
class AddYogaTypeDto {
  final String name;
  final String? description;




  AddYogaTypeDto({
    required this.name,
    this.description

  });

  factory AddYogaTypeDto.fromJson(Map<String, dynamic> json) => _$AddYogaTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddYogaTypeDtoToJson(this);
}