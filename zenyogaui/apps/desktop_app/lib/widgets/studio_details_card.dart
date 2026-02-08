import 'dart:io';
import 'package:core/dto/responses/studio_response_dto.dart';
import 'package:core/services/providers/studio_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zenyogaui/core/theme.dart';
import 'package:zenyogaui/widgets/studio_statistics_modal.dart';


import 'edit_studio_dialog.dart';
import 'studio_gallery.dart';

class StudioDetailsCard extends StatefulWidget {
  final StudioResponseDto studio;
  final StudioProvider studioProvider;
  final Map<int, String> cityNames;
  final Future<void> Function()? onReload;


  const StudioDetailsCard({
    super.key,
    required this.studio,
    required this.studioProvider,
    required this.cityNames,
    this.onReload
  });

  @override
  State<StudioDetailsCard> createState() => _StudioDetailsCardState();
}

class _StudioDetailsCardState extends State<StudioDetailsCard> {
  bool _uploadingProfilePhoto = false;
  bool _uploadingGalleryPhoto = false;
  bool _deletingGalleryPhoto = false;

  late int _studioId;
  late Future<List<String>> _galleryFuture;

  @override
  void initState() {
    super.initState();
    _studioId = widget.studio.id;
    _loadGallery();
  }

  void _loadGallery() {
    _galleryFuture = widget.studioProvider.repository.getStudioGalleryPhotos(_studioId);
  }




  Future<void> _changeProfilePhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _uploadingProfilePhoto = true);

    try {
      final file = File(picked.path);
      final newPhotoUrl = await widget.studioProvider.repository.uploadStudioPhoto(file);
      await widget.studioProvider.repository.editStudioPhoto(newPhotoUrl, _studioId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Studio profile photo updated successfully!"),
          backgroundColor: AppColors.deepGreen,
        ),
      );
      await widget.onReload?.call();
      widget.studioProvider.notifyListeners();
    } finally {
      if (mounted) setState(() => _uploadingProfilePhoto = false);
    }
  }


  Future<void> _addGalleryPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _uploadingGalleryPhoto = true);

    try {
      final file = File(picked.path);
      await widget.studioProvider.repository.uploadStudioGalleryPhoto(_studioId, file);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gallery photo added successfully!"),
          backgroundColor: AppColors.deepGreen,
        ),
      );
      // Reload gallery
      setState(() => _loadGallery());
    } finally {
      if (mounted) setState(() => _uploadingGalleryPhoto = false);
    }
  }


  Future<void> _deleteGalleryPhoto(String imageUrl) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete photo"),
        content: const Text("Are you sure you want to delete this photo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: AppColors.darkRed),),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _deletingGalleryPhoto = true);

    try {
      await widget.studioProvider.repository.deleteStudioGalleryPhoto(imageUrl, _studioId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Studio gallery photo deleted successfully!"),
          backgroundColor: AppColors.deepGreen,
        ),
      );
      // Reload gallery
      setState(() => _loadGallery());
    } finally {
      if (mounted) setState(() => _deletingGalleryPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studio = widget.studio;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studio.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lavender,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Description: ${studio.description ?? '-'}"),
                  Text("City: ${widget.cityNames[studio.cityId] ?? '-'}"),
                  Text("Address: ${studio.address ?? '-'}"),
                  Text("Phone: ${studio.contactPhone ?? '-'}"),
                  Text("Email: ${studio.contactEmail ?? '-'}"),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.bar_chart),
                        label: const Text("Statistics"),
                        style: ElevatedButton.styleFrom(fixedSize: const Size(80, 30)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (ctx) => StudioStatisticsDialog(studioId: _studioId),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                        style: ElevatedButton.styleFrom(fixedSize: const Size(80, 30)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => EditStudioDialog(
                              studioToEdit: studio,
                              onAdd: (updated) async {
                                await widget.studioProvider.repository.editStudio(updated, studio.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Studio edited successfully!"),
                                    backgroundColor: AppColors.deepGreen,
                                  ),
                                );
                                await widget.onReload?.call();
                                widget.studioProvider.notifyListeners();
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkRed, fixedSize: const Size(80, 30)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Delete studio"),
                              content: Text(
                                "Are you sure you want to delete ${studio.name}?",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(ctx);
                                    await widget.studioProvider.repository.deleteStudio(studio.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Studio deleted successfully!"),
                                        backgroundColor: AppColors.deepGreen,
                                      ),
                                    );
                                    await widget.onReload?.call();

                                  },
                                  child: const Text("Yes", style: TextStyle(color: AppColors.darkRed),),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),


            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      studio.profileImageUrl ?? '',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(height: 160, color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _uploadingProfilePhoto ? null : _changeProfilePhoto,
                    icon: _uploadingProfilePhoto
                        ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.photo_camera),
                    label: Text(_uploadingProfilePhoto ? "Uploading..." : "Change photo"),
                    style: ElevatedButton.styleFrom(fixedSize: const Size(140, 30)),
                  ),
                  const SizedBox(height: 12),
                  const Text("Gallery", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),

                  FutureBuilder<List<String>>(
                    future: _galleryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 130,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      final images = snapshot.data ?? [];
                      final canAddMore = images.length < 5;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (images.isNotEmpty)
                            Stack(
                              children: [
                                StudioGallery(
                                  images: images,
                                  onDelete: _deleteGalleryPhoto,
                                ),
                                if (_deletingGalleryPhoto)
                                  const Positioned.fill(
                                    child: ColoredBox(
                                      color: Colors.black26,
                                      child: Center(child: CircularProgressIndicator()),
                                    ),
                                  ),
                              ],
                            )
                          else
                            const Text("No gallery photos"),

                          const SizedBox(height: 8),

                          if (canAddMore)
                            ElevatedButton.icon(
                              onPressed: _uploadingGalleryPhoto ? null : _addGalleryPhoto,
                              icon: _uploadingGalleryPhoto
                                  ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : const Icon(Icons.add_photo_alternate),
                              label: Text(_uploadingGalleryPhoto ? "Uploading..." : "Add gallery photo"),
                              style: ElevatedButton.styleFrom(fixedSize: const Size(150, 30)),
                            )
                          else
                            const Text(
                              "Maximum 5 gallery photos reached",
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




