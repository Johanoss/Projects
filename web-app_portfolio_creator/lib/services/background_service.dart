import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      return [];
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
      debugPrint('📝 Saving background settings for: $email');
      
      // FIRST, fetch the existing user data
      final existingUser = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('email', email)
          .maybeSingle();
      
      if (existingUser == null) {
        debugPrint('❌ User not found with email: $email');
        return;
      }
      
      // Use update() instead of upsert() - this ONLY updates the specified columns
      await Supabase.instance.client
          .from('profiles')
          .update({
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
          })
          .eq('email', email);
      
      debugPrint('✅ Background settings saved successfully!');
    } catch (e) {
      debugPrint('❌ Error updating background settings: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchUserBackgroundSettings(String email) async {
    try {
      debugPrint('📖 Fetching background settings for: $email');
      
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
        debugPrint('⚠️ No settings found, using defaults');
        return {};
      }
      
      debugPrint('✅ Fetched settings: $response');
      return Map<String, dynamic>.from(response as Map);
    } catch (e, st) {
      debugPrint('❌ Error fetching background settings: $e');
      debugPrint('$st');
      return {};
    }
  }
}