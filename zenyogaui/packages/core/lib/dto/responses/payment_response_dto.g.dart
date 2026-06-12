// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponseDto _$PaymentResponseDtoFromJson(Map<String, dynamic> json) =>
    PaymentResponseDto(
      userId: (json['userId'] as num).toInt(),
      studioId: (json['studioId'] as num).toInt(),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$PaymentResponseDtoToJson(PaymentResponseDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'studioId': instance.studioId,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'amount': instance.amount,
      'status': instance.status,
    };
