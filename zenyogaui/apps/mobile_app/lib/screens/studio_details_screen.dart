
import 'package:core/core/constants.dart';
import 'package:core/dto/responses/groupped_classes.dart';
import 'package:core/dto/responses/instructor_response_dto.dart';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/dto/responses/user_response_dto.dart';
import 'package:core/models/yoga-type_model.dart';
import 'package:core/services/providers/class_service.dart';
import 'package:core/services/providers/instructor_service.dart';
import 'package:core/services/providers/payment_service.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:core/services/providers/user_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/controller/payment_controller.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../widgets/employee_card.dart';
import '../widgets/owner_card.dart';
import '../widgets/studio_gallery.dart';
import '../widgets/yoga_type_card.dart';

class StudioDetailsScreen extends StatefulWidget {
  final StudioResponseDto studio;
  final String cityName;
 final UserResponseDto user;
  final PaymentProvider paymentProvider;
  final PaymentController paymentController;

  const StudioDetailsScreen({
    super.key,
    required this.studio,
    required this.cityName,
  required this.user,
   required this.paymentProvider,
    required this.paymentController
  });

  @override
  State<StudioDetailsScreen> createState() => _StudioDetailsScreenState();

}

class _StudioDetailsScreenState extends State<StudioDetailsScreen> {
  bool _isLoading = false;
  bool _isMember = false;


  @override
  void initState() {
    super.initState();
    _checkMembership();
  }

  Future<void> _checkMembership() async {
    final isPaid = await context.read<PaymentProvider>().repository
        .isUserPaidMember(widget.user.id, widget.studio.id);
    setState(() => _isMember = isPaid);
  }

  Map<int, String> _buildInstructorMap(
      List<InstructorResponseDto> instructors,
      ) {
    return {
      for (final i in instructors)
        i.id: '${i.firstName} ${i.lastName}',
    };
  }

  Future<void> _handlePayment() async {
    setState(() => _isLoading = true);
    try {
      if (!_isMember) {
        await widget.paymentController.makePayment(
          currency: 'USD',
          userId: widget.user.id,
          studioId: widget.studio.id,
        );
        setState(() => _isMember = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Congratulations, you are now a member!"), backgroundColor: AppColors.deepGreen,),
        );
      }
    } catch (e) {
      setState(() => _isMember = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: Exception: ', '')),
          ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final studioProvider = context.read<StudioProvider>();
    final instructorProvider = context.read<InstructorProvider>();
    final userProvider = context.read<UserProvider>();
    final classProvider = context.read<ClassProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.studio.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:Text(
                "Membership price: ${widget.studio.membershipPrice} ${Constants.currencyUSD}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child:
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                child: ElevatedButton(
                  onPressed: (_isLoading || _isMember) ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(fixedSize: const Size(150, 50)),
                  child: _isLoading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(_isMember ? "You are a member" : "Become a member"),

                ),
              )


            ),


            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.studio.profileImageUrl ?? '',
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
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
                          Text(widget.cityName,
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (widget.studio.contactEmail?.isNotEmpty == true)
                        Row(
                          children: [
                            const Icon(Icons.email, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(widget.studio.contactEmail!,
                                style: const TextStyle(fontSize: 8)),
                          ],
                        ),
                      if (widget.studio.contactPhone?.isNotEmpty == true) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(widget.studio.contactPhone!,
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


            Text("Gallery", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            FutureBuilder<List<String>>(
              future: studioProvider.repository.getStudioGalleryPhotos(widget.studio.id),
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


            Text("Employees", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            FutureBuilder(
              future: Future.wait([
                userProvider.repository.getUser(widget.studio.ownerId),
                instructorProvider.repository.getByStudioId(widget.studio.id),
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


            const SizedBox(height: 24),
            Text("Yoga Types", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            FutureBuilder(
              future: Future.wait([
                instructorProvider.repository.getByStudioId(widget.studio.id),
                classProvider.repository.getStudioGroupped(widget.studio.id),
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
                    if (grouped.hathaYoga.isNotEmpty)
                      YogaTypeCard(
                        yogaType: YogaTypeModel(
                          id: 1,
                          name: "Hatha Yoga",
                          description: "Relaxing, slow flow yoga",
                        ),
                        classes: grouped.hathaYoga,
                        instructorMap: instructorMap,
                        studioId: widget.studio.id,
                        membershipPrice: widget.studio.membershipPrice,
                      ),
                    if (grouped.vinyasaYoga.isNotEmpty)
                      YogaTypeCard(
                        yogaType: YogaTypeModel(
                          id: 2,
                          name: "Vinyasa Yoga",
                          description: "Classic poses",
                        ),
                        classes: grouped.vinyasaYoga,
                        instructorMap: instructorMap,
                        studioId: widget.studio.id,
                        membershipPrice: widget.studio.membershipPrice,
                      ),
                    if (grouped.yinYoga.isNotEmpty)
                      YogaTypeCard(
                        yogaType: YogaTypeModel(
                          id: 3,
                          name: "Yin Yoga",
                          description: "Dynamic flowing yoga",
                        ),
                        classes: grouped.yinYoga,
                        instructorMap: instructorMap,
                        studioId: widget.studio.id,
                        membershipPrice: widget.studio.membershipPrice,
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
