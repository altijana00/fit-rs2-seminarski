import 'package:core/dto/responses/class_response_dto.dart';
import 'package:core/models/yoga-type_model.dart';
import 'package:flutter/material.dart';

import '../screens/yoga_type_screen.dart';

class YogaTypeCard extends StatelessWidget {
  final YogaTypeModel yogaType;
  final List<ClassResponseDto> classes;
  final Map<int, String> instructorMap;
  final int studioId;

  const YogaTypeCard({
    super.key,
    required this.yogaType,
    required this.classes,
    required this.instructorMap,
    required this.studioId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => YogaTypeScreen(
              yogaType: yogaType,
              classes: classes,
              instructorMap: instructorMap,
              studioId: studioId,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.self_improvement, color: Colors.deepPurple),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  yogaType.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
