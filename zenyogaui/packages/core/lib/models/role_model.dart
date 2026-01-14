
import 'package:json_annotation/json_annotation.dart';


part 'role_model.g.dart';
@JsonSerializable()
class RoleModel {
  final int id;
  final String name;

  RoleModel({
    required this.id,
    required this.name,


  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
}