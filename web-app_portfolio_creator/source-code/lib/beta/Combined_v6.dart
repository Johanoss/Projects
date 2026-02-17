//+Customization

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

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

// --- 2. USER MODEL ---
class UserModel {
  final String fName, lName, age, email, skills, hobbies;
  final String? bio; 
  final String? imageUrl; 
  final XFile? localImage;
  final String? backgroundImageUrl;
  final XFile? localBackgroundImage;
  
  UserModel({
    required this.fName, required this.lName, required this.age, 
    required this.email, this.bio, required this.skills, 
    required this.hobbies, this.imageUrl, this.localImage,
    this.backgroundImageUrl, this.localBackgroundImage,
  });
}

// --- 3. INITIALIZATION ---
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
          background: palette.background,
        ),
      ),
      home: RegistrationForm(
        onThemeChanged: changePalette,
        currentPaletteIndex: _selectedPaletteIndex,
      ),
    );
  }
}

// --- 4. CUSTOM SIDEBAR COMPONENT WITH COLOR PALETTES ---
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
        content: const Text("Bento Portfolio v2.1\nCreated with Flutter & Supabase."),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 5. FRIENDS POPUP (CLICKABLE PROFILES) ---
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
          .select('first_name, last_name, age, email, bio, skills, hobbies, image_url, background_image_url')
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

// --- 6. REGISTRATION FORM (WITH BACKGROUND AND PROFILE PICTURE) ---
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
  final _bio = TextEditingController();
  final _skills = TextEditingController();
  final _hobbies = TextEditingController();

  XFile? _profileImageFile;
  XFile? _backgroundImageFile;
  bool _isSaving = false;

  Future<void> _pickProfileImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _profileImageFile = file);
  }

  Future<void> _pickBackgroundImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _backgroundImageFile = file);
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
        'bio': _bio.text,
        'skills': _skills.text,
        'hobbies': _hobbies.text,
        'image_url': uploadedProfileUrl,
        'background_image_url': uploadedBackgroundUrl,
      }, onConflict: 'email');

      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdaptiveBentoHome(
        userData: UserModel(
          fName: _fName.text,
          lName: _lName.text,
          age: _age.text, 
          email: _email.text,
          bio: _bio.text,
          skills: _skills.text, 
          hobbies: _hobbies.text,
          imageUrl: uploadedProfileUrl, 
          localImage: _profileImageFile,
          backgroundImageUrl: uploadedBackgroundUrl,
          localBackgroundImage: _backgroundImageFile,
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
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  color: Colors.black.withOpacity(0.3),
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
                      // Background Image Container
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
                      
                      // Profile Picture - Positioned on top of background
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
                      
                      // Edit background button
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
                  _buildField("Bio", _bio, palette, lines: 3, isRequired: false),
                  const SizedBox(height: 15),
                  _buildField("Skills", _skills, palette),
                  const SizedBox(height: 15),
                  _buildField("Hobbies", _hobbies, palette),
                  const SizedBox(height: 30),
                  
                  // Save Details Button with Confirmation
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
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
}

// --- 7. ADAPTIVE BENTO HOME (WITH COLOR PALETTES) ---
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
  Future<List<Map<String, dynamic>>> _fetchFriends() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('friendships').select().eq('user_email', widget.userData.email);
    if (response.isEmpty) return [];
    final emails = response.map<String>((f) => f['friend_email'] as String).toList();
    final profiles = await supabase
        .from('profiles')
        .select('first_name, last_name, age, email, bio, skills, hobbies, image_url, background_image_url')
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
          .eq('email', widget.userData.email);

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
          MaterialPageRoute(builder: (context) => RegistrationForm(
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
    
    return Scaffold(
      backgroundColor: palette.background,
      drawer: AppSidebar(
        userData: widget.userData, 
        onRefresh: () => setState(() {}),
        onThemeChanged: widget.onThemeChanged,
        currentPaletteIndex: widget.currentPaletteIndex,
      ),
      appBar: AppBar(
        backgroundColor: palette.primaryDark.withOpacity(0.5), // CHANGED
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
            "Profile Preview",
            style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
        ),
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: palette.primaryLight,
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: LayoutBuilder(
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
                  BentoTile(
                    width: isMobile ? totalAvailableWidth : (unitW * 3) + (spacing * 2),
                    height: 320, 
                    color: palette.primary,
                    child: Stack(
                      children: [
                        // Background image with gradient fade from left
                        if (widget.userData.backgroundImageUrl != null || widget.userData.localBackgroundImage != null)
                          Positioned.fill(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Stack(
                                children: [
                                  // Background image aligned to right
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: unitW * 2.3,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: widget.userData.localBackgroundImage != null 
                                            ? (kIsWeb 
                                                ? NetworkImage(widget.userData.localBackgroundImage!.path) 
                                                : FileImage(File(widget.userData.localBackgroundImage!.path)) as ImageProvider)
                                            : NetworkImage(widget.userData.backgroundImageUrl!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay for fade effect
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
                        
                        // Profile picture on the right side
                        if (widget.userData.localImage != null || widget.userData.imageUrl != null)
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
                                backgroundImage: widget.userData.localImage != null 
                                  ? (kIsWeb 
                                      ? NetworkImage(widget.userData.localImage!.path) 
                                      : FileImage(File(widget.userData.localImage!.path)) as ImageProvider)
                                  : (widget.userData.imageUrl != null 
                                      ? NetworkImage(widget.userData.imageUrl!) 
                                      : null),
                                child: widget.userData.imageUrl == null && widget.userData.localImage == null
                                  ? Icon(Icons.person, size: 60, color: Colors.white30)
                                  : null,
                              ),
                            ),
                          )
                        else
                          // Placeholder when no profile picture
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
                        
                        // Text content on the left side
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
                                "${widget.userData.fName}\n${widget.userData.lName}", 
                                style: const TextStyle(
                                  fontSize: 34, 
                                  fontWeight: FontWeight.w900, 
                                  height: 1.1
                                )
                              ),
                              const SizedBox(height: 10),
                              if (widget.userData.bio != null && widget.userData.bio!.isNotEmpty) 
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.userData.bio!, 
                                    maxLines: 2, 
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        // Delete button at bottom right
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
                  BentoTile(
                    width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                    height: 320, 
                    color: palette.primaryDark,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        const Text("AGE", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                        Text(
                          widget.userData.age, 
                          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900)
                        ),
                        const Text("YEARS OLD", style: TextStyle(color: Colors.white24, fontSize: 9)),
                      ]
                    ),
                  ),
                  BentoTile(
                    width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                    height: 220, 
                    color: palette.skillTile,
                    child: Padding(
                      padding: const EdgeInsets.all(20), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Icon(Icons.bolt, color: palette.primaryWash, size: 20),
                          const Spacer(),
                          const Text("SKILLS", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text(
                            widget.userData.skills, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                        ]
                      )
                    ),
                  ),
                  BentoTile(
                    width: isMobile ? totalAvailableWidth : (unitW * 2) + spacing,
                    height: 220, 
                    gradient: palette.passionGradient,
                    child: Padding(
                      padding: const EdgeInsets.all(20), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [
                          const Text("PASSIONS", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text(
                            widget.userData.hobbies, 
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)
                          ),
                        ]
                      )
                    ),
                  ),
                  BentoTile(
                    width: isMobile ? totalAvailableWidth : unitW,
                    height: 220, 
                    color: Colors.white.withOpacity(0.05),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [
                          Icon(Icons.alternate_email, color: palette.primaryWash, size: 24),
                          const SizedBox(height: 12),
                          Text(
                            widget.userData.email, 
                            style: const TextStyle(fontSize: 12, color: Colors.white70)
                          ),
                        ]
                      )
                    ),
                  ),
                  BentoTile(
                    width: totalAvailableWidth,
                    height: 220, 
                    color: Colors.white.withOpacity(0.03),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- 8. BENTO TILE ---
class BentoTile extends StatefulWidget {
  final double width, height;
  final Color? color;
  final Gradient? gradient;
  final Widget child;
  const BentoTile({super.key, required this.width, required this.height, this.color, this.gradient, required this.child});
  @override
  State<BentoTile> createState() => _BentoTileState();
}

class _BentoTileState extends State<BentoTile> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.width, height: widget.height,
        transform: _h ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.color, 
          gradient: widget.gradient, 
          borderRadius: BorderRadius.circular(32), 
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(32), child: widget.child),
      ),
    );
  }
}