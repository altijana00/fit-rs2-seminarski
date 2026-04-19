
import 'package:json_annotation/json_annotation.dart';


part 'edit_yoga_type_dto.g.dart';
@JsonSerializable()
class EditYogaTypeDto {
  final String name;
  final String? description;




  EditYogaTypeDto({
    required this.name,
    this.description

  });

  factory EditYogaTypeDto.fromJson(Map<String, dynamic> json) => _$EditYogaTypeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditYogaTypeDtoToJson(this);
}