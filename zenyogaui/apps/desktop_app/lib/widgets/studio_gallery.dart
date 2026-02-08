import 'package:flutter/material.dart';

class StudioGallery extends StatefulWidget {
  final List<String> images;
  final void Function(String imageUrl) onDelete;

  const StudioGallery({
    super.key,
    required this.images,
    required this.onDelete,
  });

  @override
  State<StudioGallery> createState() => _StudioGalleryState();
}

class _StudioGalleryState extends State<StudioGallery> {
  final ScrollController _scrollController = ScrollController();

  static const double _itemSize = 80;
  static const double _scrollStep = _itemSize + 12;

  void _scrollLeft() {
    _scrollController.animateTo(
      (_scrollController.offset - _scrollStep).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      (_scrollController.offset + _scrollStep).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: _itemSize + 12,
      child: Row(
        children: [

          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _scrollController.hasClients &&
                _scrollController.offset > 0
                ? _scrollLeft
                : null,
          ),


          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(), // buttons only
              itemCount: widget.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final imageUrl = widget.images[index];

                return SizedBox(
                  width: _itemSize,
                  height: _itemSize,
                  child: Stack(
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: _itemSize,
                          height: _itemSize,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                        ),
                      ),


                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 14,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                            onPressed: () => widget.onDelete(imageUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),


          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _scrollController.hasClients &&
                _scrollController.offset <
                    _scrollController.position.maxScrollExtent
                ? _scrollRight
                : null,
          ),
        ],
      ),
    );
  }
}
