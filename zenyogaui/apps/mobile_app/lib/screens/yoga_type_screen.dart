import 'package:core/dto/responses/class_response_dto.dart';
import 'package:core/models/yoga-type_model.dart';
import 'package:core/services/providers/auth_service.dart';
import 'package:core/services/providers/payment_service.dart';
import 'package:core/services/providers/user_class_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../controller/payment_controller.dart';

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

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(c.name),
                    subtitle: Text(
                      "${c.startDate} - Instructor: $instructorName",
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        try {
                          //IF
                          if (await paymentProvider.repository.isUserPaidMember(user!.id, studioId) == false)
                          {
                            paymentController.makePayment(
                                amount: '100',
                                currency: 'EUR');
                            
                            await paymentProvider.repository.addPayment(user.id, studioId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Paid")),
                            );
                          }



                          await userClassProvider.repository.join(c.id, user!.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Joined ${c.name}")),
                          );

                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      child: const Text("Join"),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
