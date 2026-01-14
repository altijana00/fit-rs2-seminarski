import 'dart:ui';
import 'package:core/core/constants.dart';
import 'package:flutter/material.dart';


class CenteredCardLayout extends StatelessWidget {
  final Widget child;
  final String backgroundAsset; // e.g. 'assets/images/background.png'

  const CenteredCardLayout({required this.child, required this.backgroundAsset, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            backgroundAsset,
            fit: BoxFit.cover,
          ),
        ),

        // optional blur + dark overlay for better contrast
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: Colors.black.withValues(alpha:0.25, red:0.0, green:0.0, blue:0.0, colorSpace: ColorSpace.sRGB ),
            ),
          ),
        ),

        // centered card
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Constants.desktopCardWidth,
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}