
import 'package:json_annotation/json_annotation.dart';

import '../../core/payment_status_enum.dart';


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

  PaymentStatus get paymentStatus => _parsePaymentStatus(status);

  static PaymentStatus _parsePaymentStatus(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCEEDED':
        return PaymentStatus.succeeded;
      case 'REFUNDED':
        return PaymentStatus.refunded;
      case 'CANCELED':
        return PaymentStatus.canceled;
      case 'PROCESSING':
        return PaymentStatus.processing;
      default:
        return PaymentStatus.failed;
    }
  }

  factory PaymentResponseDto.fromJson(Map<String, dynamic> json) => _$PaymentResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseDtoToJson(this);
}