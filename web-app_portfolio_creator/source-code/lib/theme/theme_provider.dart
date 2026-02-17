import 'package:flutter/material.dart';
import '../models/color_palette.dart';

class ThemeProvider extends ChangeNotifier {
  int _currentPaletteIndex = 0;

  int get currentPaletteIndex => _currentPaletteIndex;
  ColorPalette get currentPalette => colorPalettes[_currentPaletteIndex];

  void changeTheme(int index) {
    if (_currentPaletteIndex != index) {
      _currentPaletteIndex = index;
      notifyListeners();
    }
  }
}