
import 'package:json_annotation/json_annotation.dart';


part 'add_role_dto.g.dart';
@JsonSerializable()
class AddRoleDto {
  final String name;
  final String? description;




  AddRoleDto({
    required this.name,
    this.description


  });

  factory AddRoleDto.fromJson(Map<String, dynamic> json) => _$AddRoleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddRoleDtoToJson(this);
}