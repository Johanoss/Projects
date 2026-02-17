import 'package:flutter/material.dart';

class ColorPalette {
  final String name;
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryWash;
  final Color background;
  final Color accent1;
  final Color accent2;
  final Color skillTile;
  final Gradient passionGradient;

  const ColorPalette({
    required this.name,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryWash,
    required this.background,
    required this.accent1,
    required this.accent2,
    required this.skillTile,
    required this.passionGradient,
  });
}

// 8 Beautiful Color Palettes
const List<ColorPalette> colorPalettes = [
  // 1. Ocean Blues (Default)
  ColorPalette(
    name: "Ocean Blue",
    primary: Color(0xFF35556E),
    primaryDark: Color(0xFF2A4458),
    primaryLight: Color(0xFF4A6F8A),
    primaryWash: Color(0xFF7694AD),
    background: Color(0xFF16202A),
    accent1: Color(0xFF3A7CA5),
    accent2: Color(0xFF81BECE),
    skillTile: Color(0xFF253A4D),
    passionGradient: LinearGradient(
      colors: [Color(0xFF4A6F8A), Color(0xFF35556E)],
    ),
  ),
  
  // 2. Forest Green
  ColorPalette(
    name: "Forest Green",
    primary: const Color(0xFF2E5C4E),
    primaryDark: const Color(0xFF23493E),
    primaryLight: const Color(0xFF3E7A68),
    primaryWash: const Color(0xFF6B9B8C),
    background: const Color(0xFF1A2F2A),
    accent1: const Color(0xFF4F997B),
    accent2: const Color(0xFF8FC1A0),
    skillTile: const Color(0xFF23493E),
    passionGradient: const LinearGradient(
      colors: [Color(0xFF3E7A68), Color(0xFF2E5C4E)],
    ),
  ),
  
  // 3. Sunset Orange
  ColorPalette(
    name: "Sunset",
    primary: const Color(0xFFB85C4A),
    primaryDark: const Color(0xFF93493B),
    primaryLight: const Color(0xFFD47C6A),
    primaryWash: const Color(0xFFE8A594),
    background: const Color(0xFF2A1E1C),
    accent1: const Color(0xFFE07A5F),
    accent2: const Color(0xFFFFB4A2),
    skillTile: const Color(0xFF6B3F36),
    passionGradient: const LinearGradient(
      colors: [Color(0xFFD47C6A), Color(0xFFB85C4A)],
    ),
  ),
  
  // 4. Royal Purple
  ColorPalette(
    name: "Royal Purple",
    primary: const Color(0xFF6B4E71),
    primaryDark: const Color(0xFF553E5A),
    primaryLight: const Color(0xFF8A6A91),
    primaryWash: const Color(0xFFB396BA),
    background: const Color(0xFF231B26),
    accent1: const Color(0xFF9F7EB0),
    accent2: const Color(0xFFD4B2D8),
    skillTile: const Color(0xFF403147),
    passionGradient: const LinearGradient(
      colors: [Color(0xFF8A6A91), Color(0xFF6B4E71)],
    ),
  ),
  
  // 5. Desert Sand
  ColorPalette(
    name: "Desert",
    primary: const Color(0xFFB48C6C),
    primaryDark: const Color(0xFF8F6F55),
    primaryLight: const Color(0xFFD4AC8C),
    primaryWash: const Color(0xFFE8CDB5),
    background: const Color(0xFF2C241E),
    accent1: const Color(0xFFC49A7B),
    accent2: const Color(0xFFE6C9A8),
    skillTile: const Color(0xFF6B5442),
    passionGradient: const LinearGradient(
      colors: [Color(0xFFD4AC8C), Color(0xFFB48C6C)],
    ),
  ),
  
  // 6. Teal Dreams
  ColorPalette(
    name: "Teal",
    primary: const Color(0xFF3C7878),
    primaryDark: const Color(0xFF2F5F5F),
    primaryLight: const Color(0xFF539898),
    primaryWash: const Color(0xFF86B8B8),
    background: const Color(0xFF1C2C2C),
    accent1: const Color(0xFF4FA3A3),
    accent2: const Color(0xFFA3D4D4),
    skillTile: const Color(0xFF2A4A4A),
    passionGradient: const LinearGradient(
      colors: [Color(0xFF539898), Color(0xFF3C7878)],
    ),
  ),
  
  // 7. Burgundy Wine
  ColorPalette(
    name: "Burgundy",
    primary: const Color(0xFF7A4A5C),
    primaryDark: const Color(0xFF613B49),
    primaryLight: const Color(0xFF9A6276),
    primaryWash: const Color(0xFFC28EA0),
    background: const Color(0xFF2A1F22),
    accent1: const Color(0xFFB26B7C),
    accent2: const Color(0xFFE3B5C0),
    skillTile: const Color(0xFF4E3940),
    passionGradient: const LinearGradient(
      colors: [Color(0xFF9A6276), Color(0xFF7A4A5C)],
    ),
  ),
  
  // 8. Slate Gray
  ColorPalette(
    name: "Slate",
    primary: const Color(0xFF4F5B66),
    primaryDark: const Color(0xFF3F4951),
    primaryLight: const Color(0xFF6A7A87),
    primaryWash: const Color(0xFF96A4B0),
    background: const Color(0xFF1E262C),
    accent1: const Color(0xFF657B8B),
    accent2: const Color(0xFFB1C2CC),
    skillTile: const Color(0xFF2F3941),
    passionGradient: const LinearGradient(
      colors: [Color(0xFF6A7A87), Color(0xFF4F5B66)],
    ),
  ),
];