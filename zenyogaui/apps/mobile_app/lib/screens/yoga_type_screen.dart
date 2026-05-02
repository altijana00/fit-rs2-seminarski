import 'package:core/dto/responses/class_response_dto.dart';
import 'package:core/models/yoga-type_model.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/payment_service.dart';
import 'package:core/services/providers/user_class_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../controller/payment_controller.dart';

final DateFormat dateFormatter = DateFormat('dd.MM.yyyy HH:mm');

class YogaTypeScreen extends StatelessWidget {
  final YogaTypeModel yogaType;
  final List<ClassResponseDto> classes;
  final Map<int, String> instructorMap;
  final int studioId;

  const YogaTypeScreen({
    super.key,
    required this.yogaType,
    required this.classes,
    required this.instructorMap,
    required this.studioId,
  });

  @override
  Widget build(BuildContext context) {
    final userClassProvider = context.read<UserClassProvider>();
    final user = context.read<AuthProvider>().user;
    final paymentController = Get.put(PaymentController());
    final paymentProvider = context.read<PaymentProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(yogaType.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/meditation.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(height: 180, color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              yogaType.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Text(
              "Upcoming Classes",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Column(
              children: classes.map((c) {
                final instructorName =
                    instructorMap[c.instructorId] ?? 'Unknown instructor';

                // Svaka kartica ima svoj loading state
                return _ClassCard(
                  yogaClass: c,
                  instructorName: instructorName,
                  user: user,
                  studioId: studioId,
                  paymentProvider: paymentProvider,
                  paymentController: paymentController,
                  userClassProvider: userClassProvider,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Izdvojen kao StatefulWidget da svaka kartica ima svoj _isLoading
class _ClassCard extends StatefulWidget {
  final ClassResponseDto yogaClass;
  final String instructorName;
  final dynamic user;
  final int studioId;
  final PaymentProvider paymentProvider;
  final PaymentController paymentController;
  final UserClassProvider userClassProvider;

  const _ClassCard({
    required this.yogaClass,
    required this.instructorName,
    required this.user,
    required this.studioId,
    required this.paymentProvider,
    required this.paymentController,
    required this.userClassProvider,
  });

  @override
  State<_ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<_ClassCard> {
  bool _isLoading = false;

  Future<void> _handleJoin() async {
    setState(() => _isLoading = true);

    try {
      final isPaid = await widget.paymentProvider.repository
          .isUserPaidMember(widget.user!.id, widget.studioId);

      // TODO REFUND DUGME
      if (!isPaid) {
        await widget.paymentController.makePayment(
          amount: 100, // TODO
          currency: 'USD',
          userId: widget.user!.id,
          studioId: widget.studioId,
        );
      }

      await widget.userClassProvider.repository
          .join(widget.yogaClass.id, widget.user!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Joined ${widget.yogaClass.name}")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(widget.yogaClass.name),
        subtitle: Text(
          "${dateFormatter.format(widget.yogaClass.startDate)} - Instructor: ${widget.instructorName}",
        ),
        trailing: ElevatedButton(
          onPressed: _isLoading ? null : _handleJoin,
          child: _isLoading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text("Join"),
        ),
      ),
    );
  }
}