import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:io';
//import '../models/color_palette.dart';
import '../models/user_model.dart';
import '../services/background_service.dart';
import '../theme/glassmorphism.dart';
import '../theme/theme_provider.dart';
import '../widgets/background_container.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'sidebar.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userData;

  const HomeScreen({
    super.key,
    required this.userData,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        _userData = _userData.copyWith(
          backgroundType: settings['background_type'] ?? _userData.backgroundType,
          backgroundValue: settings['background_value'] ?? _userData.backgroundValue,
          glassOpacity: (settings['glass_opacity'] as num?)?.toDouble() ?? _userData.glassOpacity,
          glassBlur: (settings['glass_blur'] as num?)?.toDouble() ?? _userData.glassBlur,
          glassBorderOpacity: (settings['glass_border_opacity'] as num?)?.toDouble() ?? _userData.glassBorderOpacity,
          shadowOpacity: (settings['shadow_opacity'] as num?)?.toDouble() ?? _userData.shadowOpacity,
          shadowBlur: (settings['shadow_blur'] as num?)?.toDouble() ?? _userData.shadowBlur,
          shadowOffsetX: (settings['shadow_offset_x'] as num?)?.toDouble() ?? _userData.shadowOffsetX,
          shadowOffsetY: (settings['shadow_offset_y'] as num?)?.toDouble() ?? _userData.shadowOffsetY,
          shadowColor: settings['shadow_color'] ?? _userData.shadowColor,
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final palette = themeProvider.currentPalette;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.primaryDark,
        title: Text("${user['first_name']} ${user['last_name']}", style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  child: user['image_url'] == null ? const Icon(Icons.person, size: 50, color: Colors.white30) : null,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: palette.primary.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
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
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
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
                          decoration: BoxDecoration(color: palette.skillTile, borderRadius: BorderRadius.circular(12)),
                          child: Text(user['skills'] ?? 'Not specified', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          decoration: BoxDecoration(gradient: palette.passionGradient, borderRadius: BorderRadius.circular(12)),
                          child: Text(user['hobbies'] ?? 'Not specified', style: const TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Icon(Icons.alternate_email, color: palette.primaryWash, size: 18),
                    const SizedBox(width: 12),
                    Expanded(child: Text(user['email'] ?? 'No email', style: const TextStyle(fontSize: 13, color: Colors.white70))),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final palette = themeProvider.currentPalette;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: palette.primaryDark,
          title: const Text("Delete Profile", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            "Are you sure you want to delete your profile? This action cannot be undone.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: palette.primaryWash)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
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
            child: CircularProgressIndicator(color: Provider.of<ThemeProvider>(context).currentPalette.primaryLight),
          );
        },
      );

      await Supabase.instance.client.from('profiles').delete().eq('email', _userData.email);

      if (mounted) Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile deleted successfully"), backgroundColor: Colors.green),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting profile: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.currentPalette;

    return BackgroundContainer(
      palette: palette,
      userData: _userData,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: AppSidebar(
          userData: _userData,
          onRefresh: _refreshUserData,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: palette.primaryLight,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationScreen(
                  existingUserData: _userData,
                  isEditing: true,
                ),
              ),
            );
          },
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
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          // Profile Preview Tile
                          Container(
                            width: isMobile ? totalAvailableWidth : (unitW * 3) + (spacing * 2),
                            height: 320,
                            decoration: Glassmorphism.glass(palette: palette, userData: _userData, customRadius: 32),
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
                                          border: Border.all(color: Colors.white, width: 4),
                                          boxShadow: [
                                            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: palette.primary,
                                          backgroundImage: _userData.localImage != null
                                              ? (kIsWeb
                                                  ? NetworkImage(_userData.localImage!.path)
                                                  : FileImage(File(_userData.localImage!.path)) as ImageProvider)
                                              : (_userData.imageUrl != null ? NetworkImage(_userData.imageUrl!) : null),
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
                                          border: Border.all(color: Colors.white, width: 4),
                                          boxShadow: [
                                            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
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
                                          style: TextStyle(color: Colors.white38, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "${_userData.fName}\n${_userData.lName}",
                                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1.1),
                                        ),
                                        const SizedBox(height: 10),
                                        if (_userData.bio != null && _userData.bio!.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
                                            child: Text(_userData.bio!, maxLines: 2, style: const TextStyle(color: Colors.white70, fontSize: 13)),
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
                                            BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.delete_outline, size: 18, color: Colors.white),
                                            SizedBox(width: 8),
                                            Text("Delete Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Age Tile
                          Container(
                            width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                            height: 320,
                            decoration: Glassmorphism.glass(palette: palette, userData: _userData, customRadius: 32),
                            clipBehavior: Clip.none,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("AGE", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                                  Text(_userData.age, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900)),
                                  const Text("YEARS OLD", style: TextStyle(color: Colors.white24, fontSize: 9)),
                                ],
                              ),
                            ),
                          ),

                          // Skills Tile
                          Container(
                            width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                            height: 220,
                            decoration: Glassmorphism.glass(palette: palette, userData: _userData, customRadius: 32),
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
                                    Text(_userData.skills, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Passions Tile
                          Container(
                            width: isMobile ? totalAvailableWidth : (unitW * 2) + spacing,
                            height: 220,
                            decoration: Glassmorphism.glass(palette: palette, userData: _userData, customRadius: 32),
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
                                    Text(_userData.hobbies, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Email Tile
                          Container(
                            width: isMobile ? totalAvailableWidth : unitW,
                            height: 220,
                            decoration: Glassmorphism.glass(palette: palette, userData: _userData, customRadius: 32),
                            clipBehavior: Clip.none,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.alternate_email, color: palette.primaryWash, size: 24),
                                    const SizedBox(height: 12),
                                    Text(_userData.email, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Friends Tile
                          Container(
                            width: totalAvailableWidth,
                            height: 220,
                            decoration: Glassmorphism.glass(palette: palette, userData: _userData, customRadius: 32),
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
                                    Expanded(
                                      child: FutureBuilder<List<Map<String, dynamic>>>(
                                        future: _fetchFriends(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(child: CircularProgressIndicator(color: palette.primaryLight));
                                          }
                                          final friends = snapshot.data!;
                                          if (friends.isEmpty) {
                                            return const Center(
                                              child: Text("No friends added yet.", style: TextStyle(color: Colors.white24, fontSize: 12)),
                                            );
                                          }
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
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.transparent),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 32,
                                                        backgroundImage: f['image_url'] != null ? NetworkImage(f['image_url']) : null,
                                                        backgroundColor: Colors.white10,
                                                        child: f['image_url'] == null ? const Icon(Icons.person, color: Colors.white54) : null,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text("${f['first_name']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                  );
                },
              ),
      ),
    );
  }
}