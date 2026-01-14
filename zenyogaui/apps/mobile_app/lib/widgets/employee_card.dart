import 'package:core/dto/responses/instructor_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:core/dto/responses/user_response_dto.dart';

class EmployeeCard extends StatelessWidget {
  final InstructorResponseDto instructor;

  const EmployeeCard({
    super.key,
    required this.instructor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile photo
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: instructor.profileImageUrl != null
                    ? Image.network(
                  instructor.profileImageUrl!,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey.shade300, height: 80, width: 80),
                )
                    : Container(
                  height: 80,
                  width: 80,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                "${instructor.firstName} ${instructor.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                "Instructor",
                style: const TextStyle(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              // Email
              if (instructor.email != null && instructor.email!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  instructor.email!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],

              // Diplomas
              if (instructor.diplomas != null && instructor.diplomas!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  "Diplomas: ${instructor.diplomas}",
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],

              // Certificates
              if (instructor.certificates != null && instructor.certificates!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  "Certificates: ${instructor.certificates}",
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
