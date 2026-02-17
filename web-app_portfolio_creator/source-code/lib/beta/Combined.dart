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

class UserModel {
  final String fName, lName, age, email, skills, hobbies;
  final String? bio; 
  final String? imageUrl; // Changed to store the Supabase URL
  final XFile? localImage; // For passing the preview
  
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
        scaffoldBackgroundColor: const Color(0xFF16202A),
      ),
      home: const RegistrationForm(),
    );
  }
}

// --- 3. REGISTRATION FORM (With Storage Upload) ---
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

  // Helper to upload image to Supabase Storage
  Future<String?> _uploadImage(XFile image) async {
    try {
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'public/$fileName';
      
      final bytes = await image.readAsBytes();
      
      // Uploading to bucket named 'avatars'
      await Supabase.instance.client.storage.from('avatars').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );

      // Get Public URL
      return Supabase.instance.client.storage.from('avatars').getPublicUrl(path);
    } catch (e) {
      debugPrint("Upload Error: $e");
      return null;
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      String? uploadedUrl;
      if (_imageFile != null) {
        uploadedUrl = await _uploadImage(_imageFile!);
      }

      // Pushing data to Supabase table
      await Supabase.instance.client.from('profiles').insert({
        'first_name': _fName.text,
        'last_name': _lName.text,
        'age': int.parse(_age.text),
        'email': _email.text,
        'bio': _bio.text,
        'skills': _skills.text,
        'hobbies': _hobbies.text,
        'image_url': uploadedUrl, // Now saving the actual link!
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent)
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Text("Create your own Profile!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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
                  const SizedBox(height: 30),
                  Row(children: [
                    Expanded(child: _buildField("First Name", _fName, required: true)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildField("Last Name", _lName, required: true)),
                  ]),
                  const SizedBox(height: 15),
                  Row(children: [
                    // Restored integer-only validation
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
        if (isNum && v != null && v.isNotEmpty && int.tryParse(v) == null) return 'Numbers only';
        return null;
      },
    );
  }
}

// --- 4. ADAPTIVE BENTO (Priority Image Scaling) ---
class AdaptiveBentoHome extends StatelessWidget {
  final UserModel userData;
  const AdaptiveBentoHome({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2F3D),
      floatingActionButton: FloatingActionButton(
        backgroundColor: sanJuanLight,
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final bool isMobile = width < 700;
          double hPad = isMobile ? 16 : 60;
          double space = 16.0;
          double availW = width - (hPad * 2);
          double unitW = (availW - (space * (isMobile ? 1 : 3))) / (isMobile ? 2 : 4);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 60),
            child: Center(
              child: Wrap(
                spacing: space, runSpacing: space,
                children: [
                  // --- HERO TILE: Consistent scaling & no gaps ---
                  BentoTile(
                    width: isMobile ? availW : (unitW * 3) + (space * 2),
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
                                    fit: BoxFit.cover, // Prioritize scaling
                                    width: isMobile ? availW * 0.8 : unitW * 2.5,
                                    height: 300,
                                  )
                                : Container(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("PROFILE PREVIEW", style: TextStyle(color: Colors.white38, letterSpacing: 2, fontSize: 10)),
                              const SizedBox(height: 12),
                              Text("${userData.fName}\n${userData.lName}", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, height: 1.1)),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: unitW * 1.3,
                                child: Text(userData.bio?.isEmpty ?? true ? "No bio provided." : userData.bio!, 
                                  maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white70)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  BentoTile(
                    width: isMobile ? (availW - space) / 2 : unitW,
                    height: 300, color: sanJuanDark,
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("AGE", style: TextStyle(color: Colors.white38, fontSize: 10)),
                        Text(userData.age, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                      ],
                    )),
                  ),

                  BentoTile(
                    width: isMobile ? (availW - space) / 2 : unitW,
                    height: 200, color: sanJuan.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text("SKILLS", style: TextStyle(color: Colors.white30, fontSize: 10)),
                        Text(userData.skills, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ]),
                    ),
                  ),

                  BentoTile(
                    width: isMobile ? availW : (unitW * 2) + space,
                    height: 200, gradient: const LinearGradient(colors: [sanJuanLight, sanJuan]),
                    child: Padding(padding: const EdgeInsets.all(32), child: Text("HOBBIES: ${userData.hobbies}", style: const TextStyle(fontWeight: FontWeight.bold))),
                  ),

                  BentoTile(
                    width: isMobile ? availW : unitW,
                    height: 200, color: sanJuanWash.withOpacity(0.5),
                    child: Center(child: Text(userData.email, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
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

// --- 5. REUSABLE TILE (Consistent 32px Radius) ---
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
        duration: const Duration(milliseconds: 200),
        width: widget.width, height: widget.height,
        transform: _h ? (Matrix4.identity()..scale(1.01)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.color, gradient: widget.gradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: widget.child,
        ),
      ),
    );
  }
}