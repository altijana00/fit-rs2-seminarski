
import 'package:json_annotation/json_annotation.dart';


part 'studio_model.g.dart';
@JsonSerializable()
class StudioModel {
  final int? id;
  final int? ownerId;
  final String name;
  final String? description;
  final String? address;
  final String? contactEmail;
  final String? contactPhone;
  final String? profileImageUrl;
  final int? cityId;

  StudioModel({
    this.id,
     this.ownerId,
    required this.name,
    this.description,
    this.address,
    this.contactEmail,
    this.contactPhone,
    this.profileImageUrl,
     this.cityId
  });

  factory StudioModel.fromJson(Map<String, dynamic> json) => _$StudioModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudioModelToJson(this);
}