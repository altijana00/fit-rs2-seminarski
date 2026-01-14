
import 'package:json_annotation/json_annotation.dart';


part 'add_studio_dto.g.dart';
@JsonSerializable()
class AddStudioDto {
  final int ownerId;
  final String name;
  final String? description;
  final String? address;
  final String? contactEmail;
  final String? contactPhone;
  final String? profileImageUrl;
  final int cityId;

  AddStudioDto({
    required this.ownerId,
    required this.name,
    this.description,
    this.address,
    this.contactEmail,
    this.contactPhone,
    this.profileImageUrl,
    required this.cityId
  });

  factory AddStudioDto.fromJson(Map<String, dynamic> json) => _$AddStudioDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddStudioDtoToJson(this);
}