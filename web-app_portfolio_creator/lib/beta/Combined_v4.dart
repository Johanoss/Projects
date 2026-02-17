//COMPLETE WITHOUT THE ALERTS

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

// --- 1. GLOBAL THEME & MODEL ---
const Color sanJuan = Color(0xFF35556E);
const Color sanJuanDark = Color(0xFF2A4458); 
const Color sanJuanLight = Color(0xFF4A6F8A);
const Color sanJuanWash = Color(0xFF7694AD);
const Color backgroundDark = Color(0xFF16202A);

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

// --- 2. INITIALIZATION ---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fjhusztpzzxkcgkfxebk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqaHVzenRwenp4a2Nna2Z4ZWJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzNzc0NzMsImV4cCI6MjA4NTk1MzQ3M30.KyuilJsVTraJUfJqcYCq88C2dwCqq3rkg2_oo-V7yOc',
  );
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundDark,
      ),
      home: const RegistrationForm(),
    );
  }
}

// --- 3. CUSTOM SIDEBAR COMPONENT ---
class AppSidebar extends StatelessWidget {
  final UserModel? userData;
  final VoidCallback? onRefresh;

  const AppSidebar({super.key, this.userData, this.onRefresh});

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: sanJuanDark,
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
      builder: (context) => FriendsPopup(userData: userData!),
    );
    if (onRefresh != null) onRefresh!();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: sanJuanDark, 
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
            width: double.infinity,
            decoration: const BoxDecoration(color: sanJuan),
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
                          ? const Icon(Icons.person, size: 40, color: Colors.white30) 
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
              color: sanJuanDark,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.people_outline, color: sanJuanWash),
                    title: const Text("Friends"),
                    onTap: () {
                      Navigator.pop(context);
                      _showFriendsDialog(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: sanJuanWash),
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

// --- 4. FRIENDS POPUP (CLICKABLE PROFILES) ---
class FriendsPopup extends StatefulWidget {
  final UserModel userData;
  const FriendsPopup({super.key, required this.userData});
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: sanJuanDark,
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
                  color: sanJuan.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${user['age'] ?? '?'} YEARS OLD",
                  style: const TextStyle(color: sanJuanWash, fontWeight: FontWeight.bold, fontSize: 12),
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
                            color: const Color(0xFF253A4D),
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
                            gradient: const LinearGradient(colors: [sanJuanLight, sanJuan]),
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
                    const Icon(Icons.alternate_email, color: sanJuanWash, size: 18),
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450, 
        height: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: sanJuanDark,
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
                prefixIcon: const Icon(Icons.search, color: sanJuanWash),
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
                  borderSide: const BorderSide(color: sanJuanLight, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: sanJuanLight))
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
                                    backgroundColor: sanJuanLight,
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

// --- 5. REGISTRATION FORM (WITH BACKGROUND AND PROFILE PICTURE) ---
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});
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

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      String? uploadedProfileUrl;
      String? uploadedBackgroundUrl;
      
      // Upload profile picture to avatars bucket
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
      
      // Upload background image to backgrounds bucket
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
      
      // Upsert to profiles table with both image URLs
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
      )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
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
              color: const Color(0xFF2C3E50).withOpacity(0.7),
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
                                  backgroundColor: sanJuan,
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
                                      color: sanJuanLight,
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
                    Expanded(child: _buildField("First Name", _fName)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Last Name", _lName)),
                  ]),
                  const SizedBox(height: 15),
                  Row(children: [
                    SizedBox(width: 80, child: _buildField("Age", _age, isNum: true)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Email", _email, isEmail: true)),
                  ]),
                  const SizedBox(height: 15),
                  _buildField("Bio", _bio, lines: 3, isRequired: false),
                  const SizedBox(height: 15),
                  _buildField("Skills", _skills),
                  const SizedBox(height: 15),
                  _buildField("Hobbies", _hobbies),
                  const SizedBox(height: 30),
                  
                  // Save Details Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sanJuan,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: sanJuan.withOpacity(0.5),
                        elevation: 8,
                        shadowColor: sanJuanDark,
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

  Widget _buildField(String l, TextEditingController c, {bool isNum = false, bool isEmail = false, bool isRequired = true, int lines = 1}) {
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
          borderSide: const BorderSide(color: sanJuanLight, width: 2),
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

// --- 6. ADAPTIVE BENTO HOME (WITH IMPROVED PROFILE PICTURE POSITION) ---
class AdaptiveBentoHome extends StatefulWidget {
  final UserModel userData;
  const AdaptiveBentoHome({super.key, required this.userData});
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: sanJuanDark,
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
                  color: sanJuan.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${user['age'] ?? '?'} YEARS OLD",
                  style: const TextStyle(color: sanJuanWash, fontWeight: FontWeight.bold, fontSize: 12),
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
                            color: const Color(0xFF253A4D),
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
                            gradient: const LinearGradient(colors: [sanJuanLight, sanJuan]),
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
                    const Icon(Icons.alternate_email, color: sanJuanWash, size: 18),
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
    return Scaffold(
      backgroundColor: backgroundDark,
      drawer: AppSidebar(userData: widget.userData, onRefresh: () => setState(() {})),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: sanJuanLight,
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
                    color: sanJuan,
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
                                          sanJuan,
                                          sanJuan.withOpacity(0.8),
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
                        
                        // Profile picture - Moved to the right side
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
                                backgroundColor: sanJuan,
                                backgroundImage: widget.userData.localImage != null 
                                  ? (kIsWeb 
                                      ? NetworkImage(widget.userData.localImage!.path) 
                                      : FileImage(File(widget.userData.localImage!.path)) as ImageProvider)
                                  : (widget.userData.imageUrl != null 
                                      ? NetworkImage(widget.userData.imageUrl!) 
                                      : null),
                                child: widget.userData.imageUrl == null && widget.userData.localImage == null
                                  ? const Icon(Icons.person, size: 60, color: Colors.white30)
                                  : null,
                              ),
                            ),
                          )
                        else
                          // Placeholder when no profile picture - Moved to the right side
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
                              child: const CircleAvatar(
                                radius: 60,
                                backgroundColor: sanJuan,
                                child: Icon(Icons.person, size: 60, color: Colors.white30),
                              ),
                            ),
                          ),
                        
                        // Text content - Moved to the left side
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
                      ],
                    ),
                  ),
                  BentoTile(
                    width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                    height: 320, 
                    color: sanJuanDark,
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
                    color: const Color(0xFF253A4D),
                    child: Padding(
                      padding: const EdgeInsets.all(20), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          const Icon(Icons.bolt, color: sanJuanWash, size: 20),
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
                    gradient: const LinearGradient(colors: [sanJuanLight, sanJuan]),
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
                          const Icon(Icons.alternate_email, color: sanJuanWash, size: 24),
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
                              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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