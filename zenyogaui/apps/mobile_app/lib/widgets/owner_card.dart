import 'package:flutter/material.dart';
import 'package:core/dto/responses/user_response_dto.dart';

class OwnerCard extends StatelessWidget {
  final UserResponseDto user;

  const OwnerCard({
    super.key,
    required this.user,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: user.profileImageUrl != null
                    ? Image.network(
                  user.profileImageUrl!,
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
              Text(
                "${user.firstName} ${user.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                "Owner",
                style: const TextStyle(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              if (user.email != null && user.email!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  user.email!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
