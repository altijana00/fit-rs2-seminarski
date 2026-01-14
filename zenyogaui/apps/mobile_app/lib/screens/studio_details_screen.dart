
import 'package:core/dto/responses/groupped_classes.dart';
import 'package:core/dto/responses/instructor_response_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/models/yoga-type_model.dart';
import 'package:core/services/providers/class_service.dart';
import 'package:core/services/providers/instructor_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/employee_card.dart';
import '../widgets/owner_card.dart';
import '../widgets/studio_gallery.dart';
import '../widgets/yoga_type_card.dart';

class StudioDetailsScreen extends StatelessWidget {
  final StudioResponseDto studio;
  final String cityName;

  const StudioDetailsScreen({
    super.key,
    required this.studio,
    required this.cityName,
  });

  Map<int, String> _buildInstructorMap(
      List<InstructorResponseDto> instructors,
      ) {
    return {
      for (final i in instructors)
        i.id: '${i.firstName} ${i.lastName}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final studioProvider = context.read<StudioProvider>();
    final instructorProvider = context.read<InstructorProvider>();
    final userProvider = context.read<UserProvider>();
    final classProvider = context.read<ClassProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(studio.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== PROFILE + INFO ROW =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    studio.profileImageUrl ?? '',
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 180, width: 180, color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_city, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(cityName,
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (studio.contactEmail?.isNotEmpty == true)
                        Row(
                          children: [
                            const Icon(Icons.email, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(studio.contactEmail!,
                                style: const TextStyle(fontSize: 8)),
                          ],
                        ),
                      if (studio.contactPhone?.isNotEmpty == true) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(studio.contactPhone!,
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ===== GALLERY =====
            Text("Gallery", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            FutureBuilder<List<String>>(
              future: studioProvider.repository.getStudioGalleryPhotos(studio.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Text("Error loading gallery: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red));
                }

                return StudioGalleryWidget(
                  images: snapshot.data ?? [],
                  onImageTap: (url) => showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: InteractiveViewer(
                        child: Image.network(url, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ===== EMPLOYEES =====
            Text("Employees", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            FutureBuilder(
              future: Future.wait([
                userProvider.repository.getUser(studio.ownerId),
                instructorProvider.repository.getByStudioId(studio.id),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final owner = snapshot.data![0] as UserResponseDto;
                final instructors = snapshot.data![1] as List<InstructorResponseDto>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OwnerCard(user: owner),
                    const SizedBox(height: 12),
                    ...instructors.map(
                          (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EmployeeCard(instructor: i),
                      ),
                    ),
                  ],
                );
              },
            ),

            // ===== YOGA TYPES =====
            const SizedBox(height: 24),
            Text("Yoga Types", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            FutureBuilder(
              future: Future.wait([
                instructorProvider.repository.getByStudioId(studio.id),
                classProvider.repository.getStudioGroupped(studio.id),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final instructors =
                snapshot.data![0] as List<InstructorResponseDto>;
                final grouped = snapshot.data![1] as GrouppedClasses;

                final instructorMap = _buildInstructorMap(instructors);

                return Column(
                  children: [
                    if (grouped.hathaYoga.length > 0)
                      YogaTypeCard(
                        yogaType: YogaTypeModel(
                          id: 1,
                          name: "Hatha Yoga",
                          description: "Relaxing, slow flow yoga",
                        ),
                        classes: grouped.yinYoga,
                        instructorMap: instructorMap,
                        studioId: studio.id,
                      ),
                    if (grouped.vinyasaYoga.length > 0)
                      YogaTypeCard(
                        yogaType: YogaTypeModel(
                          id: 2,
                          name: "Vinyasa Yoga",
                          description: "Classic Hatha poses",
                        ),
                        classes: grouped.hathaYoga,
                        instructorMap: instructorMap,
                        studioId: studio.id,
                      ),
                    if (grouped.yinYoga.length >0)
                      YogaTypeCard(
                        yogaType: YogaTypeModel(
                          id: 3,
                          name: "Yin Yoga",
                          description: "Dynamic flowing yoga",
                        ),
                        classes: grouped.vinyasaYoga,
                        instructorMap: instructorMap,
                        studioId: studio.id,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
