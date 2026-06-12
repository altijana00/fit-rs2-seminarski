
import 'package:json_annotation/json_annotation.dart';


part 'payment_response_dto.g.dart';
@JsonSerializable()
class PaymentResponseDto {
  final int userId;
  final int studioId;
  final DateTime paymentDate;
  final double amount;
  final String status;




  PaymentResponseDto({
    required this.userId,
    required this.studioId,
    required this.paymentDate,
    required this.amount,
    required this.status,
  });

  factory PaymentResponseDto.fromJson(Map<String, dynamic> json) => _$PaymentResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseDtoToJson(this);
}