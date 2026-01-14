
import 'package:json_annotation/json_annotation.dart';


part 'studio_response_dto.g.dart';
@JsonSerializable()
class StudioResponseDto {
  final int id;
  final int ownerId;
  final String name;
  final String? description;
  final String? address;
  final String? contactEmail;
  final String? contactPhone;
  final String? profileImageUrl;
  final int cityId;

  StudioResponseDto({
    required this.id,
    required this.ownerId,
    required this.name,
    this.description,
    this.address,
    this.contactEmail,
    this.contactPhone,
    this.profileImageUrl,
    required this.cityId
  });

  factory StudioResponseDto.fromJson(Map<String, dynamic> json) => _$StudioResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StudioResponseDtoToJson(this);
}