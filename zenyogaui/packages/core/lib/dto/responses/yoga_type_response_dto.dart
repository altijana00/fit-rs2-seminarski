

import 'package:json_annotation/json_annotation.dart';


part 'yoga_type_response_dto.g.dart';
@JsonSerializable()
class YogaTypeResponseDto {
  final int id;
  final String name;
  final String? description;


  YogaTypeResponseDto({
    required this.id,
    required this.name,
    this.description
  });

  factory YogaTypeResponseDto.fromJson(Map<String, dynamic> json) => _$YogaTypeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$YogaTypeResponseDtoToJson(this);
}