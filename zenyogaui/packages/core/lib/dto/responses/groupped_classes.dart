
import 'package:core/dto/responses/class_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'groupped_classes.g.dart';
@JsonSerializable()
class GrouppedClasses {
  final List<ClassResponseDto> hathaYoga;
  final List<ClassResponseDto> yinYoga;
  final List<ClassResponseDto> vinyasaYoga;


  GrouppedClasses({
    required this.hathaYoga,
    required this.yinYoga,
    required this.vinyasaYoga
  });


  factory GrouppedClasses.fromJson(Map<String, dynamic> json) => _$GrouppedClassesFromJson(json);

  Map<String, dynamic> toJson() => _$GrouppedClassesToJson(this);
}