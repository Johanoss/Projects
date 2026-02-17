import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/color_palette.dart';
import '../models/user_model.dart';
import '../theme/theme_provider.dart';
import 'friends_popup.dart';
import '../dialogs/background_settings_dialog.dart';
import 'login_screen.dart';

class AppSidebar extends StatelessWidget {
  final UserModel? userData;
  final VoidCallback? onRefresh;

  const AppSidebar({
    super.key,
    this.userData,
    this.onRefresh,
  });

  void _showAbout(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final palette = themeProvider.currentPalette;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.primaryDark,
        title: const Text("About"),
        content: const Text(
            "Bento Portfolio Final Version\nCreated with Flutter & Supabase.\n+ Customization Design"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void _showFriendsDialog(BuildContext context) async {
    if (userData == null) return;
    await showDialog(
      context: context,
      builder: (context) => FriendsPopup(
        userData: userData!,
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
        onSettingsChanged: () {
          if (onRefresh != null) onRefresh!();
        },
      ),
    );
  }

  void _showColorPaletteDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final palette = themeProvider.currentPalette;
    
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
                  themeProvider.changeTheme(index);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: p.primary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: themeProvider.currentPaletteIndex == index
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.currentPalette.primaryDark,
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
                  builder: (context) => const LoginScreen(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.currentPalette;

    return Drawer(
      backgroundColor: palette.primaryDark,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 30, bottom: 30, left: 20, right: 20),
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
                            ? (kIsWeb
                                ? NetworkImage(userData!.localImage!.path)
                                : FileImage(File(userData!.localImage!.path))
                                    as ImageProvider)
                            : (userData?.imageUrl != null
                                ? NetworkImage(userData!.imageUrl!)
                                : null),
                        child: (userData?.imageUrl == null &&
                                userData?.localImage == null)
                            ? Icon(Icons.person, size: 40, color: Colors.white30)
                            : null,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        userData != null
                            ? "${userData!.fName} ${userData!.lName}"
                            : "Guest",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        (userData?.bio != null && userData!.bio!.isNotEmpty)
                            ? userData!.bio!
                            : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 12),
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