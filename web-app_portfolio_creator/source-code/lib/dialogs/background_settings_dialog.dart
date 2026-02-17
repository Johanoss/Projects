import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/color_palette.dart';
import '../models/user_model.dart';
import '../services/background_service.dart';
import '../theme/theme_provider.dart';

class BackgroundSettingsDialog extends StatefulWidget {
  final UserModel userData;
  final VoidCallback onSettingsChanged;

  const BackgroundSettingsDialog({
    super.key,
    required this.userData,
    required this.onSettingsChanged,
  });

  @override
  State<BackgroundSettingsDialog> createState() =>
      _BackgroundSettingsDialogState();
}

class _BackgroundSettingsDialogState extends State<BackgroundSettingsDialog> {
  String _selectedType = 'color';
  String? _selectedBackgroundValue;
  double _glassOpacity = 0.3;
  double _glassBlur = 10;
  double _glassBorderOpacity = 0.2;
  double _shadowOpacity = 0.3;
  double _shadowBlur = 20;
  double _shadowOffsetX = 0;
  double _shadowOffsetY = 10;
  String? _shadowColor;
  List<Map<String, dynamic>> _presetBackgrounds = [];
  bool _isLoadingPresets = false;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.userData.backgroundType ?? 'color';
    _selectedBackgroundValue = widget.userData.backgroundValue;
    _glassOpacity = widget.userData.glassOpacity;
    _glassBlur = widget.userData.glassBlur;
    _glassBorderOpacity = widget.userData.glassBorderOpacity;
    _shadowOpacity = widget.userData.shadowOpacity;
    _shadowBlur = widget.userData.shadowBlur;
    _shadowOffsetX = widget.userData.shadowOffsetX;
    _shadowOffsetY = widget.userData.shadowOffsetY;
    _shadowColor = widget.userData.shadowColor;
    _fetchPresetBackgrounds();
  }

  Future<void> _fetchPresetBackgrounds() async {
    setState(() => _isLoadingPresets = true);
    final presets = await BackgroundService.fetchPresetBackgrounds();
    setState(() {
      _presetBackgrounds = presets;
      _isLoadingPresets = false;
    });
  }

  Future<void> _pickCustomBackground() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      final url = await BackgroundService.uploadUserBackground(file);
      if (url != null) {
        setState(() {
          _selectedBackgroundValue = url;
          _selectedType = 'image';
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    String? finalShadowColor;
    if (_selectedType == 'color' && _selectedBackgroundValue != null) {
      finalShadowColor = _selectedBackgroundValue;
    } else {
      finalShadowColor = _shadowColor;
    }

    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    await BackgroundService.updateBackgroundSettings(
      email: widget.userData.email,
      backgroundType: _selectedType,
      backgroundValue: _selectedBackgroundValue,
      glassOpacity: _glassOpacity,
      glassBlur: _glassBlur,
      glassBorderOpacity: _glassBorderOpacity,
      shadowOpacity: _shadowOpacity,
      shadowBlur: _shadowBlur,
      shadowOffsetX: _shadowOffsetX,
      shadowOffsetY: _shadowOffsetY,
      shadowColor: finalShadowColor,
    );

    if (mounted) Navigator.pop(context); // Close loading
    if (mounted) Navigator.pop(context); // Close dialog
    
    // Trigger refresh in home screen
    widget.onSettingsChanged();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.currentPalette;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: palette.primaryDark,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white10),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Background Settings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text("Background Type",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  _buildTypeChip("Color", "color", palette),
                  _buildTypeChip("Gradient", "gradient", palette),
                  _buildTypeChip("Image/GIF", "image", palette),
                ],
              ),

              const SizedBox(height: 20),

              if (_selectedType == 'color') ...[
                const Text("Select Color",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildColorOption(palette.background, "Dark", palette),
                    _buildColorOption(
                        palette.primaryDark, "Primary Dark", palette),
                    _buildColorOption(palette.primary, "Primary", palette),
                    _buildColorOption(const Color(0xFF1A1A1A), "Black", palette),
                    _buildColorOption(const Color(0xFF2A2A2A), "Gray", palette),
                  ],
                ),
              ],

              if (_selectedType == 'gradient') ...[
                const Text("Gradient Style",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildGradientOption(
                        "Ocean", [palette.primary, palette.primaryDark], palette),
                    _buildGradientOption("Sunset",
                        [Colors.orange[700]!, Colors.purple[900]!], palette),
                    _buildGradientOption("Forest",
                        [Colors.green[800]!, Colors.teal[900]!], palette),
                    _buildGradientOption("Royal",
                        [Colors.purple[700]!, Colors.indigo[900]!], palette),
                  ],
                ),
              ],

              if (_selectedType == 'image') ...[
                const Text("Choose Background",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _pickCustomBackground,
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Custom Background"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primaryLight,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                if (_isLoadingPresets)
                  const Center(child: CircularProgressIndicator())
                else if (_presetBackgrounds.isEmpty)
                  Center(
                    child: Text(
                      "No preset backgrounds available",
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                else
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _presetBackgrounds.length,
                      itemBuilder: (context, index) {
                        final bg = _presetBackgrounds[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedBackgroundValue = bg['url'];
                            });
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedBackgroundValue == bg['url']
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    bg['thumbnail_url'] ?? bg['url']),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                bg['name'] ?? 'Background',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],

              const SizedBox(height: 30),

              const Text(
                "Glass Effect",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildSlider("Opacity", _glassOpacity, 0.1, 0.8,
                  (val) => _glassOpacity = val, palette),
              _buildSlider("Blur", _glassBlur, 0, 30,
                  (val) => _glassBlur = val, palette),
              _buildSlider("Border Opacity", _glassBorderOpacity, 0, 0.5,
                  (val) => _glassBorderOpacity = val, palette),

              const SizedBox(height: 20),

              const Text(
                "Shadow Effect",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildSlider("Shadow Opacity", _shadowOpacity, 0, 0.8,
                  (val) => _shadowOpacity = val, palette),
              _buildSlider("Shadow Blur", _shadowBlur, 0, 50,
                  (val) => _shadowBlur = val, palette),
              _buildSlider("Shadow Offset X", _shadowOffsetX, -20, 20,
                  (val) => _shadowOffsetX = val, palette),
              _buildSlider("Shadow Offset Y", _shadowOffsetY, -20, 20,
                  (val) => _shadowOffsetY = val, palette),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primaryLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Apply Settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, String type, ColorPalette palette) {
    return FilterChip(
      label: Text(label),
      selected: _selectedType == type,
      onSelected: (selected) {
        if (!selected) return;
        setState(() {
          _selectedType = type;
          if (type == 'color' || type == 'gradient') {
            _selectedBackgroundValue = null;
          }
        });
      },
      backgroundColor: Colors.white10,
      selectedColor: palette.primaryLight,
      labelStyle: TextStyle(
        color: _selectedType == type ? Colors.white : Colors.white70,
      ),
    );
  }

  Widget _buildColorOption(Color color, String label, ColorPalette palette) {
    final colorHex = '#${color.value.toRadixString(16).substring(2)}';
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBackgroundValue = colorHex;
        });
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedBackgroundValue == colorHex
                    ? Colors.white
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildGradientOption(
      String label, List<Color> colors, ColorPalette palette) {
    final gradientStr = 'gradient:${colors.map((c) => c.value).join(',')}';
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBackgroundValue = gradientStr;
        });
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedBackgroundValue?.startsWith('gradient:') ==
                            true &&
                        _selectedBackgroundValue
                            ?.contains(colors[0].value.toString()) ==
                            true
                    ? Colors.white
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    ColorPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            const Spacer(),
            Text(value.toStringAsFixed(2),
                style: TextStyle(
                    color: palette.primaryLight, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          activeColor: palette.primaryLight,
          inactiveColor: Colors.white24,
          onChanged: (val) {
            setState(() {
              onChanged(val);
            });
          },
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}