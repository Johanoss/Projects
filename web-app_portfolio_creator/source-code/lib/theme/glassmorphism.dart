import 'package:flutter/material.dart';
import '../models/color_palette.dart';
import '../models/user_model.dart';

class Glassmorphism {
  static BoxDecoration glass({
    required ColorPalette palette,
    required UserModel userData,
    double? customOpacity,
    double? customBlur,
    double? customBorderOpacity,
    double? customRadius,
  }) {
    final opacity = customOpacity ?? userData.glassOpacity;
    final borderOpacity = customBorderOpacity ?? userData.glassBorderOpacity;
    final radius = customRadius ?? 32;
    
    return BoxDecoration(
      color: palette.primaryDark.withOpacity(opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withOpacity(borderOpacity),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: _getShadowColor(palette, userData),
          blurRadius: userData.shadowBlur,
          offset: Offset(
            userData.shadowOffsetX,
            userData.shadowOffsetY,
          ),
        ),
      ],
    );
  }

  static Color _getShadowColor(ColorPalette palette, UserModel userData) {
    final fallback = palette.primary.withOpacity(userData.shadowOpacity);
    final raw = userData.shadowColor;
    if (raw == null || raw.isEmpty) return fallback;
    try {
      final hex = raw.replaceAll('#', '');
      final value = int.parse('0xFF$hex');
      return Color(value).withOpacity(userData.shadowOpacity);
    } catch (_) {
      return fallback;
    }
  }
}