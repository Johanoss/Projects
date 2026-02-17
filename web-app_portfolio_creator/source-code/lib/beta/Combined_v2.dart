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
  
  UserModel({
    required this.fName, required this.lName, required this.age, 
    required this.email, this.bio, required this.skills, 
    required this.hobbies, this.imageUrl, this.localImage
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
  const AppSidebar({super.key, this.userData});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: sanJuanDark,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("About", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Bento Portfolio Creator. Built with Flutter and Supabase. A modern grid UI for personal profiles.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white10),
              const Text("Version 2.5.0 (Polished UI)", style: TextStyle(color: Colors.white24, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  void _showFriendsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FriendsPopup(),
    );
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
          const Divider(height: 1, color: Colors.white10, thickness: 1),
          Expanded(
            child: Container(
              color: sanJuanDark,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: sanJuanWash),
                    title: const Text("About"),
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_outline, color: sanJuanWash),
                    title: const Text("Friends"),
                    onTap: () {
                      Navigator.pop(context);
                      _showFriendsDialog(context);
                    },
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

// --- 4. FRIENDS SEARCH & PROFILE CARDS ---
class FriendsPopup extends StatefulWidget {
  const FriendsPopup({super.key});
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
          .select()
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

  void _openFriendCard(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: sanJuan,
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: user['image_url'] != null ? NetworkImage(user['image_url']) : null,
                child: user['image_url'] == null ? const Icon(Icons.person, size: 50) : null,
              ),
              const SizedBox(height: 20),
              Text("${user['first_name']} ${user['last_name']}", 
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(user['bio'] ?? "No bio shared.", 
                textAlign: TextAlign.center, 
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    _cardRow(Icons.bolt, "Skills", user['skills'] ?? "N/A"),
                    const Divider(color: Colors.white10),
                    _cardRow(Icons.favorite, "Hobbies", user['hobbies'] ?? "N/A"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(user['email'] ?? "", style: const TextStyle(color: sanJuanWash, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: sanJuanWash),
        const SizedBox(width: 10),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450, height: 500,
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
                IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: _searchUsers,
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: const Icon(Icons.search, color: sanJuanWash),
                filled: true, fillColor: Colors.black26,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: sanJuanLight))
                : _results.isEmpty 
                  ? const Center(child: Text("No users found", style: TextStyle(color: Colors.white24)))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final user = _results[index];
                        return ListTile(
                          onTap: () => _openFriendCard(user),
                          leading: CircleAvatar(
                            backgroundImage: user['image_url'] != null ? NetworkImage(user['image_url']) : null,
                            child: user['image_url'] == null ? const Icon(Icons.person) : null,
                          ),
                          title: Text("${user['first_name']} ${user['last_name']}"),
                          subtitle: const Text("View Profile", style: TextStyle(fontSize: 10, color: Colors.white38)),
                          trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.white24),
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

// --- 5. REGISTRATION FORM ---
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

  XFile? _imageFile;
  bool _isSaving = false;

  Future<void> _pick() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _imageFile = file);
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'public/$fileName';
      final bytes = await image.readAsBytes();
      await Supabase.instance.client.storage.from('avatars').uploadBinary(
        path, bytes, fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
      return Supabase.instance.client.storage.from('avatars').getPublicUrl(path);
    } catch (e) { return null; }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      String? uploadedUrl;
      if (_imageFile != null) {
        uploadedUrl = await _uploadImage(_imageFile!);
      }
      
      await Supabase.instance.client.from('profiles').insert({
        'first_name': _fName.text, 
        'last_name': _lName.text,
        'age': int.parse(_age.text), 
        'email': _email.text,
        'bio': _bio.text.isEmpty ? null : _bio.text,
        'skills': _skills.text, 
        'hobbies': _hobbies.text,
        'image_url': uploadedUrl,
      });

      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdaptiveBentoHome(
        userData: UserModel(
          fName: _fName.text, lName: _lName.text, age: _age.text, 
          email: _email.text, bio: _bio.text, skills: _skills.text, 
          hobbies: _hobbies.text, imageUrl: uploadedUrl, localImage: _imageFile,
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E50).withOpacity(0.5),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("Create your Profile!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: _pick,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white10,
                      backgroundImage: _imageFile != null 
                        ? (kIsWeb ? NetworkImage(_imageFile!.path) : FileImage(File(_imageFile!.path)) as ImageProvider) 
                        : null,
                      child: _imageFile == null ? const Icon(Icons.camera_alt, color: Colors.white30) : null,
                    ),
                  ),
                  const Text("Photo (Optional)", style: TextStyle(fontSize: 10, color: Colors.white38)),
                  const SizedBox(height: 30),
                  Row(children: [
                    Expanded(child: _buildField("First Name", _fName, required: true)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Last Name", _lName, required: true)),
                  ]),
                  const SizedBox(height: 15),
                  Row(children: [
                    SizedBox(width: 80, child: _buildField("Age", _age, isNum: true, required: true)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Email", _email, required: true)),
                  ]),
                  const SizedBox(height: 15),
                  _buildField("Short Bio (Optional)", _bio, lines: 3),
                  const SizedBox(height: 15),
                  _buildField("Skills", _skills, required: true),
                  const SizedBox(height: 15),
                  _buildField("Hobbies", _hobbies, required: true),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity, height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3E5C76), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: _isSaving ? null : _handleSave,
                      child: _isSaving 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text("Save Details", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String l, TextEditingController c, {bool isNum = false, int lines = 1, bool required = false}) {
    return TextFormField(
      controller: c, maxLines: lines, keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: l, filled: true, fillColor: Colors.black12,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (v) {
        if (required && (v == null || v.isEmpty)) return 'Required';
        return null;
      },
    );
  }
}

// --- 6. POLISHED ADAPTIVE BENTO HOME ---
class AdaptiveBentoHome extends StatelessWidget {
  final UserModel userData;
  const AdaptiveBentoHome({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      drawer: AppSidebar(userData: userData),
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  // HERO TILE (Wide - Profile & Bio)
                  BentoTile(
                    width: isMobile ? totalAvailableWidth : (unitW * 3) + (spacing * 2),
                    height: 300,
                    color: sanJuan,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ShaderMask(
                              shaderCallback: (rect) => const LinearGradient(
                                begin: Alignment.centerRight, end: Alignment.centerLeft,
                                colors: [Colors.black, Colors.transparent],
                              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height)),
                              blendMode: BlendMode.dstIn,
                              child: (userData.localImage != null || userData.imageUrl != null)
                                ? Image(
                                    image: userData.localImage != null 
                                      ? (kIsWeb ? NetworkImage(userData.localImage!.path) : FileImage(File(userData.localImage!.path)) as ImageProvider)
                                      : NetworkImage(userData.imageUrl!),
                                    fit: BoxFit.cover,
                                    width: isMobile ? totalAvailableWidth * 0.7 : unitW * 2.3,
                                    height: 300,
                                  )
                                : Container(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("PROFILE PREVIEW", style: TextStyle(color: Colors.white38, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Text("${userData.fName}\n${userData.lName}", style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1.1)),
                              const SizedBox(height: 12),
                              if (userData.bio != null && userData.bio!.isNotEmpty)
                                Container(
                                  constraints: BoxConstraints(maxWidth: isMobile ? 180 : unitW * 1.5),
                                  child: Text(userData.bio!, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, height: 1.4)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // AGE TILE (Centered Focus)
                  BentoTile(
                    width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                    height: 300,
                    color: sanJuanDark,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("AGE", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(userData.age, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: Colors.white)),
                        const Text("YEARS OLD", style: TextStyle(color: Colors.white24, fontSize: 9)),
                      ],
                    ),
                  ),

                  // SKILLS TILE (Bottom-Aligned Content)
                  BentoTile(
                    width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                    height: 220,
                    color: const Color(0xFF253A4D),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bolt, color: sanJuanWash, size: 20),
                          const Spacer(),
                          const Text("SKILLS", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(userData.skills, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2), maxLines: 3, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),

                  // HOBBIES TILE (Gradient Wide)
                  BentoTile(
                    width: isMobile ? totalAvailableWidth : (unitW * 2) + spacing,
                    height: 220,
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [sanJuanLight, sanJuan]),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("PASSIONS & HOBBIES", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text(userData.hobbies, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white, height: 1.3)),
                        ],
                      ),
                    ),
                  ),

                  // EMAIL TILE (Subtle/Clean)
                  BentoTile(
                    width: isMobile ? totalAvailableWidth : unitW,
                    height: 220,
                    color: Colors.white.withOpacity(0.05),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.alternate_email, color: sanJuanWash),
                            const SizedBox(height: 12),
                            Text(userData.email, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70)),
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
    );
  }
}

// --- 7. REUSABLE TILE (Consistent 32px Radius) ---
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
        curve: Curves.easeOutCubic,
        width: widget.width, height: widget.height,
        transform: _h ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.color, gradient: widget.gradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: widget.child,
        ),
      ),
    );
  }
}