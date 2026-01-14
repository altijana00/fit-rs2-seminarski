

import 'package:json_annotation/json_annotation.dart';


part 'role_response_dto.g.dart';
@JsonSerializable()
class RoleResponseDto {
  final int id;
  final String name;
  final String? description;


  RoleResponseDto({
    required this.id,
    required this.name,
    this.description
  });

  factory RoleResponseDto.fromJson(Map<String, dynamic> json) => _$RoleResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RoleResponseDtoToJson(this);
}