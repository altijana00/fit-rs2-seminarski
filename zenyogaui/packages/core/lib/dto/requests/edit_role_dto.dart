
import 'package:json_annotation/json_annotation.dart';


part 'edit_role_dto.g.dart';
@JsonSerializable()
class EditRoleDto {
  final String name;
  final String? description;




  EditRoleDto({
    required this.name,
    this.description


  });

  factory EditRoleDto.fromJson(Map<String, dynamic> json) => _$EditRoleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditRoleDtoToJson(this);
}