
import 'package:json_annotation/json_annotation.dart';


part 'edit_studio_dto.g.dart';
@JsonSerializable()
class EditStudioDto {
  final String name;
  final String? description;
  final String? address;
  final String? contactEmail;
  final String? contactPhone;
  final String? profileImageUrl;


  EditStudioDto({
    required this.name,
    this.description,
    this.address,
    this.contactEmail,
    this.contactPhone,
    this.profileImageUrl,

  });

  factory EditStudioDto.fromJson(Map<String, dynamic> json) => _$EditStudioDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditStudioDtoToJson(this);
}