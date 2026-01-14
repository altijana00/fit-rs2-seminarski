import 'package:flutter/material.dart';

class StudioGalleryWidget extends StatelessWidget {
  final List<String> images;
  final void Function(String) onImageTap;

  const StudioGalleryWidget({
    super.key,
    required this.images,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final url = images[index];
          return GestureDetector(
            onTap: () => onImageTap(url),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                url,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade300, width: 120, height: 120),
              ),
            ),
          );
        },
      ),
    );
  }
}
