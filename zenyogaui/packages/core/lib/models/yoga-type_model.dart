
import 'package:json_annotation/json_annotation.dart';


part 'yoga-type_model.g.dart';
@JsonSerializable()
class YogaTypeModel {
  final int id;
  final String name;
  final String description;

  YogaTypeModel({
    required this.id,
    required this.name,
    required this.description


  });

  factory YogaTypeModel.fromJson(Map<String, dynamic> json) => _$YogaTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$YogaTypeModelToJson(this);
}