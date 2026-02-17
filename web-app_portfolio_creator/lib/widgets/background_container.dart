import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/color_palette.dart';
import '../models/user_model.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final UserModel? userData;
  final ColorPalette palette;

  const BackgroundContainer({
    super.key,
    required this.child,
    this.userData,
    required this.palette,
  });

  Color? _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final cleaned = hex.replaceAll('#', '');
      if (cleaned.length == 6) {
        return Color(int.parse('0xFF$cleaned'));
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final data = userData;
    if (data == null || data.backgroundType == null) {
      return Container(color: palette.background, child: child);
    }

    switch (data.backgroundType) {
      case 'color':
        Color bgColor = palette.background;
        if (data.backgroundValue != null) {
          final customColor = _parseHexColor(data.backgroundValue);
          if (customColor != null) bgColor = customColor;
        }
        return Container(color: bgColor, child: child);

      case 'image':
      case 'gif':
        final url = data.backgroundValue;
        if (url == null || url.isEmpty) {
          return Container(color: palette.background, child: child);
        }
        return Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: palette.background),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: data.glassBlur,
                sigmaY: data.glassBlur,
              ),
              child: Container(
                color: palette.background.withOpacity(data.glassOpacity),
              ),
            ),
            child,
          ],
        );

      case 'gradient':
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [palette.primary, palette.primaryDark, palette.background],
            ),
          ),
          child: child,
        );

      default:
        return Container(color: palette.background, child: child);
    }
  }
}