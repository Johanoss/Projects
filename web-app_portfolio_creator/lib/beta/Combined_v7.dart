import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:ui';

// --- 1. COLOR PALETTE SYSTEM ---
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

  ColorPalette({
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
final List<ColorPalette> colorPalettes = [
  // 1. Ocean Blues (Default)
  ColorPalette(
    name: "Ocean Blue",
    primary: const Color(0xFF35556E),
    primaryDark: const Color(0xFF2A4458),
    primaryLight: const Color(0xFF4A6F8A),
    primaryWash: const Color(0xFF7694AD),
    background: const Color(0xFF16202A),
    accent1: const Color(0xFF3A7CA5),
    accent2: const Color(0xFF81BECE),
    skillTile: const Color(0xFF253A4D),
    passionGradient: const LinearGradient(
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

// --- 2. USER MODEL WITH PASSWORD AND GLASSMORPHISM SETTINGS ---
class UserModel {
  final String fName;
  final String lName;
  final String age;
  final String email;
  final String password;
  final String skills;
  final String hobbies;

  final String? bio;
  final String? imageUrl;
  final XFile? localImage;

  final String? backgroundImageUrl;
  final XFile? localBackgroundImage;

  final String? backgroundType;
  final String? backgroundValue;

  final double glassOpacity;
  final double glassBlur;
  final double glassBorderOpacity;

  final String? shadowColor;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetX;
  final double shadowOffsetY;

  const UserModel({
    required this.fName,
    required this.lName,
    required this.age,
    required this.email,
    required this.password,
    required this.skills,
    required this.hobbies,
    this.bio,
    this.imageUrl,
    this.localImage,
    this.backgroundImageUrl,
    this.localBackgroundImage,
    this.backgroundType = 'color',
    this.backgroundValue,
    this.glassOpacity = 0.3,
    this.glassBlur = 10,
    this.glassBorderOpacity = 0.2,
    this.shadowColor,
    this.shadowOpacity = 0.3,
    this.shadowBlur = 20,
    this.shadowOffsetX = 0,
    this.shadowOffsetY = 10,
  });
}

// --- 3. BACKGROUND SERVICE FOR SUPABASE ---
class BackgroundService {
  static Future<List<Map<String, dynamic>>> fetchPresetBackgrounds() async {
    try {
      final response = await Supabase.instance.client
          .from('preset_backgrounds')
          .select()
          .order('category', ascending: true);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e, st) {
      debugPrint('Error fetching preset backgrounds: $e');
      debugPrint('$st');
      return <Map<String, dynamic>>[];
    }
  }

  static Future<String?> uploadUserBackground(XFile file) async {
    try {
      final fileName = 'user_bg_${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}';
      final bytes = await file.readAsBytes();
      await Supabase.instance.client.storage
          .from('user_backgrounds')
          .uploadBinary('public/$fileName', bytes);
      return Supabase.instance.client.storage
          .from('user_backgrounds')
          .getPublicUrl('public/$fileName');
    } catch (e) {
      debugPrint('Error uploading background: $e');
      return null;
    }
  }

  static Future<void> updateBackgroundSettings({
    required String email,
    required String backgroundType,
    String? backgroundValue,
    double? glassOpacity,
    double? glassBlur,
    double? glassBorderOpacity,
    String? shadowColor,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetX,
    double? shadowOffsetY,
  }) async {
    try {
      await Supabase.instance.client.from('profiles').upsert({
        'email': email,
        'background_type': backgroundType,
        'background_value': backgroundValue,
        'glass_opacity': glassOpacity,
        'glass_blur': glassBlur,
        'glass_border_opacity': glassBorderOpacity,
        'shadow_color': shadowColor,
        'shadow_opacity': shadowOpacity,
        'shadow_blur': shadowBlur,
        'shadow_offset_x': shadowOffsetX,
        'shadow_offset_y': shadowOffsetY,
      }, onConflict: 'email');
    } catch (e) {
      debugPrint('Error updating background settings: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchUserBackgroundSettings(
      String email) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select(
            'background_type, background_value, glass_opacity, glass_blur, '
            'glass_border_opacity, shadow_color, shadow_opacity, shadow_blur, '
            'shadow_offset_x, shadow_offset_y',
          )
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        return <String, dynamic>{};
      }
      return Map<String, dynamic>.from(response as Map);
    } catch (e, st) {
      debugPrint('Error fetching background settings: $e');
      debugPrint('$st');
      return <String, dynamic>{};
    }
  }
}

// --- 4. GLASSMORPHISM STYLING CLASS ---
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
    // final blur = customBlur ?? userData.glassBlur;
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
    if (raw == null || raw.isEmpty) {
      return fallback;
    }

    try {
      final hex = raw.replaceAll('#', '');
      final value = int.parse('0xFF$hex');
      return Color(value).withOpacity(userData.shadowOpacity);
    } catch (_) {
      return fallback;
    }
  }
}

// --- 5. BACKGROUND CONTAINER WIDGET (FIXED) ---
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
        // Try to parse custom color, fallback to palette background
        Color bgColor = palette.background;
        if (data.backgroundValue != null) {
          final customColor = _parseHexColor(data.backgroundValue);
          if (customColor != null) {
            bgColor = customColor;
          }
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
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: palette.background),
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
              colors: [
                palette.primary,
                palette.primaryDark,
                palette.background,
              ],
            ),
          ),
          child: child,
        );

      default:
        return Container(color: palette.background, child: child);
    }
  }
}

// --- 6. BACKGROUND SETTINGS DIALOG (FIXED) ---
class BackgroundSettingsDialog extends StatefulWidget {
  final UserModel userData;
  final int currentPaletteIndex;
  final VoidCallback onSettingsChanged;

  const BackgroundSettingsDialog({
    super.key,
    required this.userData,
    required this.currentPaletteIndex,
    required this.onSettingsChanged,
  });

  @override
  State<BackgroundSettingsDialog> createState() => _BackgroundSettingsDialogState();
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
  // XFile? _customBackgroundFile;

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

  /*Future<void> _pickCustomBackground() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _customBackgroundFile = file);
      final url = await BackgroundService.uploadUserBackground(file);
      if (url != null) {
        setState(() {
          _selectedBackgroundValue = url;
          _selectedType = 'image';
        });
      }
    }
  }*/

  Future<void> _saveSettings() async {
    // Determine shadow color based on selection
    String? finalShadowColor;
    if (_selectedType == 'color' && _selectedBackgroundValue != null) {
      finalShadowColor = _selectedBackgroundValue;
    } else {
      finalShadowColor = _shadowColor;
    }

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
    
    widget.onSettingsChanged();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final palette = colorPalettes[widget.currentPaletteIndex];

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
              
              const Text("Background Type", style: TextStyle(fontWeight: FontWeight.bold)),
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
                const Text("Select Color", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildColorOption(palette.background, "Dark", palette),
                    _buildColorOption(palette.primaryDark, "Primary Dark", palette),
                    _buildColorOption(palette.primary, "Primary", palette),
                    _buildColorOption(const Color(0xFF1A1A1A), "Black", palette),
                    _buildColorOption(const Color(0xFF2A2A2A), "Gray", palette),
                  ],
                ),
              ],
              
              if (_selectedType == 'gradient') ...[
                const Text("Gradient Style", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildGradientOption("Ocean", [palette.primary, palette.primaryDark], palette),
                    _buildGradientOption("Sunset", [Colors.orange[700]!, Colors.purple[900]!], palette),
                    _buildGradientOption("Forest", [Colors.green[800]!, Colors.teal[900]!], palette),
                    _buildGradientOption("Royal", [Colors.purple[700]!, Colors.indigo[900]!], palette),
                  ],
                ),
              ],
              
              if (_selectedType == 'image') ...[
                const Text("Choose Background", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                /*ElevatedButton.icon(
                  onPressed: _pickCustomBackground,
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Custom Background"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primaryLight,
                    foregroundColor: Colors.white,
                  ),
                ),*/
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
                                image: NetworkImage(bg['thumbnail_url'] ?? bg['url']),
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
              _buildSlider("Opacity", _glassOpacity, 0.1, 0.8, (val) => _glassOpacity = val, palette),
              _buildSlider("Blur", _glassBlur, 0, 30, (val) => _glassBlur = val, palette),
              _buildSlider("Border Opacity", _glassBorderOpacity, 0, 0.5, (val) => _glassBorderOpacity = val, palette),
              
              const SizedBox(height: 20),
              
              const Text(
                "Shadow Effect",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildSlider("Shadow Opacity", _shadowOpacity, 0, 0.8, (val) => _shadowOpacity = val, palette),
              _buildSlider("Shadow Blur", _shadowBlur, 0, 50, (val) => _shadowBlur = val, palette),
              _buildSlider("Shadow Offset X", _shadowOffsetX, -20, 20, (val) => _shadowOffsetX = val, palette),
              _buildSlider("Shadow Offset Y", _shadowOffsetY, -20, 20, (val) => _shadowOffsetY = val, palette),
              
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

  Widget _buildGradientOption(String label, List<Color> colors, ColorPalette palette) {
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
                color: _selectedBackgroundValue?.startsWith('gradient:') == true &&
                    _selectedBackgroundValue?.contains(colors[0].value.toString()) == true
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
            Text(label),
            const Spacer(),
            Text(value.toStringAsFixed(2)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          activeColor: palette.accent1,
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

// --- 7. INITIALIZATION ---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fjhusztpzzxkcgkfxebk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqaHVzenRwenp4a2Nna2Z4ZWJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzNzc0NzMsImV4cCI6MjA4NTk1MzQ3M30.KyuilJsVTraJUfJqcYCq88C2dwCqq3rkg2_oo-V7yOc',
  );
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});
  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  int _selectedPaletteIndex = 0;
  
  void changePalette(int index) {
    setState(() {
      _selectedPaletteIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = colorPalettes[_selectedPaletteIndex];
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: palette.background,
        primaryColor: palette.primary,
        colorScheme: ColorScheme.dark(
          primary: palette.primary,
          secondary: palette.primaryLight,
          surface: palette.primaryDark,
        ),
      ),
      home: LoginForm(
        onThemeChanged: changePalette,
        currentPaletteIndex: _selectedPaletteIndex,
      ),
    );
  }
}

// --- 8. LOGIN FORM ---
class LoginForm extends StatefulWidget {
  final Function(int) onThemeChanged;
  final int currentPaletteIndex;

  const LoginForm({
    super.key,
    required this.onThemeChanged,
    required this.currentPaletteIndex,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('email', _email.text)
          .eq('password', _password.text)
          .maybeSingle();

      if (response == null) {
        throw Exception('Invalid email or password');
      }

      final userData = Map<String, dynamic>.from(response as Map);
      
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdaptiveBentoHome(
            userData: UserModel(
              fName: userData['first_name'] ?? '',
              lName: userData['last_name'] ?? '',
              age: userData['age']?.toString() ?? '0',
              email: userData['email'] ?? '',
              password: userData['password'] ?? '',
              bio: userData['bio'],
              skills: userData['skills'] ?? '',
              hobbies: userData['hobbies'] ?? '',
              imageUrl: userData['image_url'],
              backgroundImageUrl: userData['background_image_url'],
              backgroundType: userData['background_type'] ?? 'color',
              backgroundValue: userData['background_value'],
              glassOpacity: (userData['glass_opacity'] as num?)?.toDouble() ?? 0.3,
              glassBlur: (userData['glass_blur'] as num?)?.toDouble() ?? 10,
              glassBorderOpacity: (userData['glass_border_opacity'] as num?)?.toDouble() ?? 0.2,
              shadowOpacity: (userData['shadow_opacity'] as num?)?.toDouble() ?? 0.3,
              shadowBlur: (userData['shadow_blur'] as num?)?.toDouble() ?? 20,
              shadowOffsetX: (userData['shadow_offset_x'] as num?)?.toDouble() ?? 0,
              shadowOffsetY: (userData['shadow_offset_y'] as num?)?.toDouble() ?? 10,
              shadowColor: userData['shadow_color'],
            ),
            currentPaletteIndex: widget.currentPaletteIndex,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString().replaceAll('Exception:', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = colorPalettes[widget.currentPaletteIndex];

    return Scaffold(
      drawer: AppSidebar(
        onThemeChanged: widget.onThemeChanged,
        currentPaletteIndex: widget.currentPaletteIndex,
      ),
      appBar: AppBar(
        backgroundColor: palette.primaryDark.withOpacity(0.5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Login",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: palette.primaryDark.withOpacity(0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: palette.primary.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Login to your account",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 15),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(val)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                      prefixIcon: Icon(Icons.email, color: palette.primaryWash),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.primaryLight, width: 2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  TextFormField(
                    controller: _password,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 15),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Password is required';
                      }
                      if (val.length < 4) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                      prefixIcon: Icon(Icons.lock, color: palette.primaryWash),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white54,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.25),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: palette.primaryLight, width: 2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: palette.primary.withOpacity(0.5),
                        elevation: 8,
                        shadowColor: palette.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationForm(
                                onThemeChanged: widget.onThemeChanged,
                                currentPaletteIndex: widget.currentPaletteIndex,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: palette.primaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}

// --- 9. CUSTOM SIDEBAR COMPONENT ---
class AppSidebar extends StatelessWidget {
  final UserModel? userData;
  final VoidCallback? onRefresh;
  final Function(int) onThemeChanged;
  final int currentPaletteIndex;

  const AppSidebar({
    super.key, 
    this.userData, 
    this.onRefresh,
    required this.onThemeChanged,
    required this.currentPaletteIndex,
  });

  void _showAbout(BuildContext context) {
    final palette = colorPalettes[currentPaletteIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.primaryDark,
        title: const Text("About"),
        content: const Text("Bento Portfolio v3.0\nCreated with Flutter & Supabase.\nGlassmorphism Edition ✨"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
      ),
    );
  }

  void _showFriendsDialog(BuildContext context) async {
    if (userData == null) return;
    await showDialog(
      context: context,
      builder: (context) => FriendsPopup(
        userData: userData!,
        currentPaletteIndex: currentPaletteIndex,
      ),
    );
    if (onRefresh != null) onRefresh!();
  }

  void _showBackgroundSettingsDialog(BuildContext context) {
    if (userData == null) return;
    showDialog(
      context: context,
      builder: (context) => BackgroundSettingsDialog(
        userData: userData!,
        currentPaletteIndex: currentPaletteIndex,
        onSettingsChanged: () {
          if (onRefresh != null) onRefresh!();
        },
      ),
    );
  }

  void _showColorPaletteDialog(BuildContext context) {
    final palette = colorPalettes[currentPaletteIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.primaryDark,
        title: const Text(
          "Choose Theme",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 300,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: colorPalettes.length,
            itemBuilder: (context, index) {
              final p = colorPalettes[index];
              return GestureDetector(
                onTap: () {
                  onThemeChanged(index);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: p.primary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: currentPaletteIndex == index 
                        ? Colors.white 
                        : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: p.primary.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: p.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: p.primaryLight,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: p.accent1,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorPalettes[currentPaletteIndex].primaryDark,
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginForm(
                    onThemeChanged: onThemeChanged,
                    currentPaletteIndex: currentPaletteIndex,
                  ),
                ),
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = colorPalettes[currentPaletteIndex];
    
    return Drawer(
      backgroundColor: palette.primaryDark, 
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
            width: double.infinity,
            decoration: BoxDecoration(color: palette.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white10,
                        backgroundImage: userData?.localImage != null 
                          ? (kIsWeb ? NetworkImage(userData!.localImage!.path) : FileImage(File(userData!.localImage!.path)) as ImageProvider)
                          : (userData?.imageUrl != null ? NetworkImage(userData!.imageUrl!) : null),
                        child: (userData?.imageUrl == null && userData?.localImage == null) 
                          ? Icon(Icons.person, size: 40, color: Colors.white30) 
                          : null,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        userData != null ? "${userData!.fName} ${userData!.lName}" : "Guest",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        (userData?.bio != null && userData!.bio!.isNotEmpty) ? userData!.bio! : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: palette.primaryDark,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.palette, color: palette.primaryWash),
                    title: const Text("Themes"),
                    onTap: () {
                      Navigator.pop(context);
                      _showColorPaletteDialog(context);
                    },
                  ),
                  if (userData != null)
                    ListTile(
                      leading: Icon(Icons.wallpaper, color: palette.primaryWash),
                      title: const Text("Background"),
                      onTap: () {
                        Navigator.pop(context);
                        _showBackgroundSettingsDialog(context);
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.people_outline, color: palette.primaryWash),
                    title: const Text("Friends"),
                    onTap: () {
                      Navigator.pop(context);
                      _showFriendsDialog(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: palette.primaryWash),
                    title: const Text("About"),
                    onTap: () => _showAbout(context),
                  ),
                  if (userData != null)
                    ListTile(
                      leading: Icon(Icons.logout, color: palette.primaryWash),
                      title: const Text("Logout"),
                      onTap: () => _logout(context),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 10. FRIENDS POPUP ---
class FriendsPopup extends StatefulWidget {
  final UserModel userData;
  final int currentPaletteIndex;

  const FriendsPopup({
    super.key, 
    required this.userData,
    required this.currentPaletteIndex,
  });
  
  @override
  State<FriendsPopup> createState() => _FriendsPopupState();
}

class _FriendsPopupState extends State<FriendsPopup> {
  List<dynamic> _results = [];
  bool _isLoading = false;

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('first_name, last_name, age, email, bio, skills, hobbies, image_url, background_image_url, background_type, background_value, glass_opacity, glass_blur')
          .or('first_name.ilike.%$query%,last_name.ilike.%$query%')
          .limit(10);

      setState(() {
        _results = response as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addFriend(String friendEmail) async {
    final supabase = Supabase.instance.client;
    await supabase.from('friendships').upsert([
      { 'user_email': widget.userData.email, 'friend_email': friendEmail },
      { 'user_email': friendEmail, 'friend_email': widget.userData.email }
    ]);
    if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Friend Added!")));
  }

  void _viewProfile(Map<String, dynamic> user) {
    final palette = colorPalettes[widget.currentPaletteIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.primaryDark,
        title: Text(
          "${user['first_name']} ${user['last_name']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white10,
                  backgroundImage: user['image_url'] != null ? NetworkImage(user['image_url']) : null,
                  child: user['image_url'] == null 
                    ? const Icon(Icons.person, size: 50, color: Colors.white30) 
                    : null,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${user['age'] ?? '?'} YEARS OLD",
                  style: TextStyle(color: palette.primaryWash, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              if (user['bio'] != null && user['bio'].toString().isNotEmpty) ...[
                const Text("BIO", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(user['bio'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SKILLS", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: palette.skillTile,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user['skills'] ?? 'Not specified',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("PASSIONS", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: palette.passionGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user['hobbies'] ?? 'Not specified',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.alternate_email, color: palette.primaryWash, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user['email'] ?? 'No email',
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = colorPalettes[widget.currentPaletteIndex];
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450, 
        height: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: palette.primaryDark,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Friends", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54), 
                  onPressed: () => Navigator.pop(context)
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: _searchUsers,
              decoration: InputDecoration(
                hintText: "Search by name...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: palette.primaryWash),
                filled: true, 
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), 
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: palette.primaryLight, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading 
                ? Center(child: CircularProgressIndicator(color: palette.primaryLight))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final user = _results[index];
                      if (user['email'] == widget.userData.email) return const SizedBox.shrink();
                      return Card(
                        color: Colors.transparent,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          onTap: () => _viewProfile(user),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: user['image_url'] != null ? NetworkImage(user['image_url']) : null,
                                  backgroundColor: Colors.white10,
                                  child: user['image_url'] == null 
                                    ? const Icon(Icons.person, color: Colors.white54) 
                                    : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user['first_name']} ${user['last_name']}",
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      if (user['skills'] != null)
                                        Text(
                                          user['skills'],
                                          style: const TextStyle(color: Colors.white60, fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: palette.primaryLight,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  onPressed: () => _addFriend(user['email']),
                                  child: const Text("Add", style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 11. REGISTRATION FORM ---
class RegistrationForm extends StatefulWidget {
  final Function(int) onThemeChanged;
  final int currentPaletteIndex;

  const RegistrationForm({
    super.key, 
    required this.onThemeChanged,
    required this.currentPaletteIndex,
  });
  
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _age = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _bio = TextEditingController();
  final _skills = TextEditingController();
  final _hobbies = TextEditingController();

  XFile? _profileImageFile;
  XFile? _backgroundImageFile;
  bool _isSaving = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _pickProfileImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _profileImageFile = file);
  }

  Future<void> _pickBackgroundImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _backgroundImageFile = file);
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _password.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _showSaveConfirmation() async {
    if (!_formKey.currentState!.validate()) return;
    final palette = colorPalettes[widget.currentPaletteIndex];
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: palette.primaryDark,
          title: const Text(
            "Save Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to save this profile?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: palette.primaryWash),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primaryLight,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                _handleSave();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      String? uploadedProfileUrl;
      String? uploadedBackgroundUrl;
      
      if (_profileImageFile != null) {
        final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await _profileImageFile!.readAsBytes();
        await Supabase.instance.client.storage
            .from('avatars')
            .uploadBinary('public/$fileName', bytes);
        uploadedProfileUrl = Supabase.instance.client.storage
            .from('avatars')
            .getPublicUrl('public/$fileName');
      }
      
      if (_backgroundImageFile != null) {
        final fileName = 'background_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await _backgroundImageFile!.readAsBytes();
        await Supabase.instance.client.storage
            .from('backgrounds')
            .uploadBinary('public/$fileName', bytes);
        uploadedBackgroundUrl = Supabase.instance.client.storage
            .from('backgrounds')
            .getPublicUrl('public/$fileName');
      }
      
      await Supabase.instance.client.from('profiles').upsert({
        'first_name': _fName.text,
        'last_name': _lName.text,
        'age': int.parse(_age.text),
        'email': _email.text,
        'password': _password.text,
        'bio': _bio.text,
        'skills': _skills.text,
        'hobbies': _hobbies.text,
        'image_url': uploadedProfileUrl,
        'background_image_url': uploadedBackgroundUrl,
        'background_type': 'color',
        'glass_opacity': 0.3,
        'glass_blur': 10,
        'glass_border_opacity': 0.2,
        'shadow_opacity': 0.3,
        'shadow_blur': 20,
        'shadow_offset_x': 0,
        'shadow_offset_y': 10,
      }, onConflict: 'email');

      if (!mounted) return;
      
      final settings = await BackgroundService.fetchUserBackgroundSettings(_email.text);
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdaptiveBentoHome(
        userData: UserModel(
          fName: _fName.text,
          lName: _lName.text,
          age: _age.text, 
          email: _email.text,
          password: _password.text,
          bio: _bio.text,
          skills: _skills.text, 
          hobbies: _hobbies.text,
          imageUrl: uploadedProfileUrl, 
          localImage: _profileImageFile,
          backgroundImageUrl: uploadedBackgroundUrl,
          localBackgroundImage: _backgroundImageFile,
          backgroundType: settings['background_type'] ?? 'color',
          backgroundValue: settings['background_value'],
          glassOpacity: (settings['glass_opacity'] as num?)?.toDouble() ?? 0.3,
          glassBlur: (settings['glass_blur'] as num?)?.toDouble() ?? 10,
          glassBorderOpacity: (settings['glass_border_opacity'] as num?)?.toDouble() ?? 0.2,
          shadowOpacity: (settings['shadow_opacity'] as num?)?.toDouble() ?? 0.3,
          shadowBlur: (settings['shadow_blur'] as num?)?.toDouble() ?? 20,
          shadowOffsetX: (settings['shadow_offset_x'] as num?)?.toDouble() ?? 0,
          shadowOffsetY: (settings['shadow_offset_y'] as num?)?.toDouble() ?? 10,
          shadowColor: settings['shadow_color'],
        ),
        currentPaletteIndex: widget.currentPaletteIndex,
        onThemeChanged: widget.onThemeChanged,
      )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = colorPalettes[widget.currentPaletteIndex];
    
    return Scaffold(
      drawer: AppSidebar(
        onThemeChanged: widget.onThemeChanged,
        currentPaletteIndex: widget.currentPaletteIndex,
      ),
      appBar: AppBar(
        backgroundColor: palette.primaryDark.withOpacity(0.5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Create Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: palette.primaryDark.withOpacity(0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: palette.primary.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Create Profile",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Background image section
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickBackgroundImage,
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20),
                            image: _backgroundImageFile != null
                              ? DecorationImage(
                                  image: kIsWeb 
                                    ? NetworkImage(_backgroundImageFile!.path) 
                                    : FileImage(File(_backgroundImageFile!.path)) as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                          ),
                          child: _backgroundImageFile == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 40, color: Colors.white.withOpacity(0.5)),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Tap to add background image",
                                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                                  ),
                                ],
                              )
                            : null,
                        ),
                      ),
                      
                      Positioned(
                        left: 24,
                        bottom: -30,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: _pickProfileImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: palette.primary,
                                  backgroundImage: _profileImageFile != null 
                                    ? (kIsWeb ? NetworkImage(_profileImageFile!.path) : FileImage(File(_profileImageFile!.path)) as ImageProvider)
                                    : null,
                                  child: _profileImageFile == null
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.camera_alt, size: 30, color: Colors.white70),
                                          SizedBox(height: 5),
                                          Text(
                                            "Add Photo",
                                            style: TextStyle(fontSize: 11, color: Colors.white70),
                                          ),
                                        ],
                                      )
                                    : null,
                                ),
                              ),
                            ),
                            if (_profileImageFile != null)
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: palette.primaryLight,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      if (_backgroundImageFile != null)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: _pickBackgroundImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.edit, size: 16, color: Colors.white70),
                                  SizedBox(width: 4),
                                  Text("Change", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 50),
                  
                  Row(children: [
                    Expanded(child: _buildField("First Name", _fName, palette)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Last Name", _lName, palette)),
                  ]),
                  const SizedBox(height: 15),
                  
                  Row(children: [
                    SizedBox(width: 80, child: _buildField("Age", _age, palette, isNum: true)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Email", _email, palette, isEmail: true)),
                  ]),
                  const SizedBox(height: 15),
                  
                  _buildPasswordField("Password", _password, palette,
                    obscureText: _obscurePassword,
                    onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 15),
                  _buildPasswordField("Confirm Password", _confirmPassword, palette,
                    obscureText: _obscureConfirmPassword,
                    onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 15),
                  
                  _buildField("Bio", _bio, palette, lines: 3, isRequired: false),
                  const SizedBox(height: 15),
                  _buildField("Skills", _skills, palette),
                  const SizedBox(height: 15),
                  _buildField("Hobbies", _hobbies, palette),
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _showSaveConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: palette.primary.withOpacity(0.5),
                        elevation: 8,
                        shadowColor: palette.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSaving
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Save Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginForm(
                                onThemeChanged: widget.onThemeChanged,
                                currentPaletteIndex: widget.currentPaletteIndex,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: palette.primaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String l, TextEditingController c, ColorPalette palette, {bool isNum = false, bool isEmail = false, bool isRequired = true, int lines = 1}) {
    return TextFormField(
      controller: c, 
      maxLines: lines, 
      keyboardType: isNum ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text), 
      style: const TextStyle(fontSize: 15),
      validator: (val) {
        if (!isRequired) return null;
        if (val == null || val.isEmpty) return "Required";
        if (isEmail) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(val)) return "Invalid format";
        }
        if (isNum && int.tryParse(val) == null) return "Enter a number";
        return null;
      },
      decoration: InputDecoration(
        labelText: l,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        filled: true, 
        fillColor: Colors.black.withOpacity(0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.5), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    ColorPalette palette, {
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 15),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        filled: true,
        fillColor: Colors.black.withOpacity(0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.withOpacity(0.5), width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white54,
          ),
          onPressed: onToggle,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  @override
  void dispose() {
    _fName.dispose();
    _lName.dispose();
    _age.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _bio.dispose();
    _skills.dispose();
    _hobbies.dispose();
    super.dispose();
  }
}

// --- 12. ADAPTIVE BENTO HOME (FIXED WITH CLIPBEHAVIOR) ---
class AdaptiveBentoHome extends StatefulWidget {
  final UserModel userData;
  final int currentPaletteIndex;
  final Function(int) onThemeChanged;

  const AdaptiveBentoHome({
    super.key, 
    required this.userData,
    required this.currentPaletteIndex,
    required this.onThemeChanged,
  });
  
  @override
  State<AdaptiveBentoHome> createState() => _AdaptiveBentoHomeState();
}

class _AdaptiveBentoHomeState extends State<AdaptiveBentoHome> {
  late UserModel _userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userData = widget.userData;
    _refreshUserData();
  }

  Future<void> _refreshUserData() async {
    setState(() => _isLoading = true);
    try {
      final settings = await BackgroundService.fetchUserBackgroundSettings(widget.userData.email);
      setState(() {
        _userData = UserModel(
          fName: widget.userData.fName,
          lName: widget.userData.lName,
          age: widget.userData.age,
          email: widget.userData.email,
          password: widget.userData.password,
          bio: widget.userData.bio,
          skills: widget.userData.skills,
          hobbies: widget.userData.hobbies,
          imageUrl: widget.userData.imageUrl,
          localImage: widget.userData.localImage,
          backgroundImageUrl: widget.userData.backgroundImageUrl,
          localBackgroundImage: widget.userData.localBackgroundImage,
          backgroundType: settings['background_type'] ?? widget.userData.backgroundType,
          backgroundValue: settings['background_value'] ?? widget.userData.backgroundValue,
          glassOpacity: (settings['glass_opacity'] as num?)?.toDouble() ?? widget.userData.glassOpacity,
          glassBlur: (settings['glass_blur'] as num?)?.toDouble() ?? widget.userData.glassBlur,
          glassBorderOpacity: (settings['glass_border_opacity'] as num?)?.toDouble() ?? widget.userData.glassBorderOpacity,
          shadowOpacity: (settings['shadow_opacity'] as num?)?.toDouble() ?? widget.userData.shadowOpacity,
          shadowBlur: (settings['shadow_blur'] as num?)?.toDouble() ?? widget.userData.shadowBlur,
          shadowOffsetX: (settings['shadow_offset_x'] as num?)?.toDouble() ?? widget.userData.shadowOffsetX,
          shadowOffsetY: (settings['shadow_offset_y'] as num?)?.toDouble() ?? widget.userData.shadowOffsetY,
          shadowColor: settings['shadow_color'] ?? widget.userData.shadowColor,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<List<Map<String, dynamic>>> _fetchFriends() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('friendships').select().eq('user_email', _userData.email);
    if (response.isEmpty) return [];
    final emails = response.map<String>((f) => f['friend_email'] as String).toList();
    final profiles = await supabase
        .from('profiles')
        .select('first_name, last_name, age, email, bio, skills, hobbies, image_url, background_image_url, background_type, background_value')
        .inFilter('email', emails);
    return List<Map<String, dynamic>>.from(profiles);
  }

  void _viewProfile(Map<String, dynamic> user) {
    final palette = colorPalettes[widget.currentPaletteIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.primaryDark,
        title: Text(
          "${user['first_name']} ${user['last_name']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white10,
                  backgroundImage: user['image_url'] != null ? NetworkImage(user['image_url']) : null,
                  child: user['image_url'] == null 
                    ? const Icon(Icons.person, size: 50, color: Colors.white30) 
                    : null,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${user['age'] ?? '?'} YEARS OLD",
                  style: TextStyle(color: palette.primaryWash, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              if (user['bio'] != null && user['bio'].toString().isNotEmpty) ...[
                const Text("BIO", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(user['bio'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SKILLS", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: palette.skillTile,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user['skills'] ?? 'Not specified',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("PASSIONS", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: palette.passionGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user['hobbies'] ?? 'Not specified',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.alternate_email, color: palette.primaryWash, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user['email'] ?? 'No email',
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final palette = colorPalettes[widget.currentPaletteIndex];
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: palette.primaryDark,
          title: const Text(
            "Delete Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete your profile? This action cannot be undone.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: palette.primaryWash),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _deleteProfile();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProfile() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(color: colorPalettes[widget.currentPaletteIndex].primaryLight),
          );
        },
      );

      await Supabase.instance.client
          .from('profiles')
          .delete()
          .eq('email', _userData.email);

      if (mounted) Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginForm(
            onThemeChanged: widget.onThemeChanged,
            currentPaletteIndex: widget.currentPaletteIndex,
          )),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error deleting profile: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = colorPalettes[widget.currentPaletteIndex];
    
    return BackgroundContainer(
      palette: palette,
      userData: _userData,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: AppSidebar(
          userData: _userData, 
          onRefresh: _refreshUserData,
          onThemeChanged: widget.onThemeChanged,
          currentPaletteIndex: widget.currentPaletteIndex,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          iconTheme: const IconThemeData(color: Colors.white)
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: palette.primaryLight,
          onPressed: () => Navigator.pop(context),
          child: const Icon(Icons.edit, color: Colors.white),
        ),
        body: _isLoading
          ? Center(child: CircularProgressIndicator(color: palette.primaryLight))
          : LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final bool isMobile = width < 750;
                
                final double hPad = isMobile ? 16 : 40; 
                const double spacing = 16.0; 
                
                final double totalAvailableWidth = width - (hPad * 2);
                final int columns = isMobile ? 2 : 4;
                final double unitW = (totalAvailableWidth - (spacing * (columns - 1))) / columns;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
                  child: Center(
                    child: Wrap(
                      spacing: spacing, runSpacing: spacing,
                      children: [
                        // Profile Preview Tile with Glassmorphism (FIXED)
                        Container(
                          width: isMobile ? totalAvailableWidth : (unitW * 3) + (spacing * 2),
                          height: 320,
                          decoration: Glassmorphism.glass(
                            palette: palette,
                            userData: _userData,
                            customRadius: 32,
                          ),
                          clipBehavior: Clip.none,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Stack(
                              children: [
                                if (_userData.backgroundImageUrl != null || _userData.localBackgroundImage != null)
                                  Positioned.fill(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              width: unitW * 2.3,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: _userData.localBackgroundImage != null 
                                                    ? (kIsWeb 
                                                        ? NetworkImage(_userData.localBackgroundImage!.path) 
                                                        : FileImage(File(_userData.localBackgroundImage!.path)) as ImageProvider)
                                                    : NetworkImage(_userData.backgroundImageUrl!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  palette.primary,
                                                  palette.primary.withOpacity(0.8),
                                                  Colors.transparent,
                                                ],
                                                stops: const [0.0, 0.4, 0.8],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                
                                if (_userData.localImage != null || _userData.imageUrl != null)
                                  Positioned(
                                    right: 28,
                                    top: 28,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: palette.primary,
                                        backgroundImage: _userData.localImage != null 
                                          ? (kIsWeb 
                                              ? NetworkImage(_userData.localImage!.path) 
                                              : FileImage(File(_userData.localImage!.path)) as ImageProvider)
                                          : (_userData.imageUrl != null 
                                              ? NetworkImage(_userData.imageUrl!) 
                                              : null),
                                        child: _userData.imageUrl == null && _userData.localImage == null
                                          ? Icon(Icons.person, size: 60, color: Colors.white30)
                                          : null,
                                      ),
                                    ),
                                  )
                                else
                                  Positioned(
                                    right: 28,
                                    top: 28,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: palette.primary,
                                        child: const Icon(Icons.person, size: 60, color: Colors.white30),
                                      ),
                                    ),
                                  ),
                                
                                Padding(
                                  padding: const EdgeInsets.all(28), 
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, 
                                    mainAxisAlignment: MainAxisAlignment.center, 
                                    children: [
                                      const Text(
                                        "PROFILE PREVIEW", 
                                        style: TextStyle(
                                          color: Colors.white38, 
                                          letterSpacing: 2, 
                                          fontSize: 10, 
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "${_userData.fName}\n${_userData.lName}", 
                                        style: const TextStyle(
                                          fontSize: 34, 
                                          fontWeight: FontWeight.w900, 
                                          height: 1.1
                                        )
                                      ),
                                      const SizedBox(height: 10),
                                      if (_userData.bio != null && _userData.bio!.isNotEmpty) 
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            _userData.bio!, 
                                            maxLines: 2, 
                                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: () => _showDeleteConfirmation(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.delete_outline, size: 18, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text(
                                            "Delete Profile",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Age Tile (FIXED)
                        Container(
                          width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                          height: 320,
                          decoration: Glassmorphism.glass(
                            palette: palette,
                            userData: _userData,
                            customRadius: 32,
                          ),
                          clipBehavior: Clip.none,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                const Text("AGE", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                                Text(
                                  _userData.age, 
                                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900)
                                ),
                                const Text("YEARS OLD", style: TextStyle(color: Colors.white24, fontSize: 9)),
                              ]
                            ),
                          ),
                        ),
                        
                        // Skills Tile (FIXED)
                        Container(
                          width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                          height: 220,
                          decoration: Glassmorphism.glass(
                            palette: palette,
                            userData: _userData,
                            customRadius: 32,
                          ),
                          clipBehavior: Clip.none,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Padding(
                              padding: const EdgeInsets.all(20), 
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                children: [
                                  Icon(Icons.bolt, color: palette.primaryWash, size: 20),
                                  const Spacer(),
                                  const Text("SKILLS", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                                  Text(
                                    _userData.skills, 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                  ),
                                ]
                              )
                            ),
                          ),
                        ),
                        
                        // Passions Tile (FIXED)
                        Container(
                          width: isMobile ? totalAvailableWidth : (unitW * 2) + spacing,
                          height: 220,
                          decoration: Glassmorphism.glass(
                            palette: palette,
                            userData: _userData,
                            customRadius: 32,
                          ),
                          clipBehavior: Clip.none,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Padding(
                              padding: const EdgeInsets.all(20), 
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                mainAxisAlignment: MainAxisAlignment.center, 
                                children: [
                                  const Text("PASSIONS", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                                  Text(
                                    _userData.hobbies, 
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)
                                  ),
                                ]
                              )
                            ),
                          ),
                        ),
                        
                        // Email Tile (FIXED)
                        Container(
                          width: isMobile ? totalAvailableWidth : unitW,
                          height: 220,
                          decoration: Glassmorphism.glass(
                            palette: palette,
                            userData: _userData,
                            customRadius: 32,
                          ),
                          clipBehavior: Clip.none,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, 
                                children: [
                                  Icon(Icons.alternate_email, color: palette.primaryWash, size: 24),
                                  const SizedBox(height: 12),
                                  Text(
                                    _userData.email, 
                                    style: const TextStyle(fontSize: 12, color: Colors.white70)
                                  ),
                                ]
                              )
                            ),
                          ),
                        ),
                        
                        // Friends Tile (FIXED)
                        Container(
                          width: totalAvailableWidth,
                          height: 220,
                          decoration: Glassmorphism.glass(
                            palette: palette,
                            userData: _userData,
                            customRadius: 32,
                          ),
                          clipBehavior: Clip.none,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Padding(
                              padding: const EdgeInsets.all(20), 
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                children: [
                                  const Text("FRIENDS", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  Expanded(child: FutureBuilder<List<Map<String, dynamic>>>(
                                    future: _fetchFriends(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: palette.primaryLight));
                                      final friends = snapshot.data!;
                                      if (friends.isEmpty) return const Center(child: Text("No friends added yet.", style: TextStyle(color: Colors.white24, fontSize: 12)));
                                      return ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: friends.length,
                                        separatorBuilder: (_, __) => const SizedBox(width: 20),
                                        itemBuilder: (context, i) {
                                          final f = friends[i];
                                          return GestureDetector(
                                            onTap: () => _viewProfile(f),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                color: Colors.transparent,
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 32, 
                                                    backgroundImage: f['image_url'] != null ? NetworkImage(f['image_url']) : null,
                                                    backgroundColor: Colors.white10,
                                                    child: f['image_url'] == null 
                                                      ? const Icon(Icons.person, color: Colors.white54) 
                                                      : null,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "${f['first_name']}",
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                  ),
                                                  if (f['skills'] != null)
                                                    Text(
                                                      f['skills'],
                                                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )),
                                ]
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}