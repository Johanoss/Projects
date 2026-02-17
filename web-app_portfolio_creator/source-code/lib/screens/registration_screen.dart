import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:io';
//import '../models/color_palette.dart';
import '../models/user_model.dart';
import '../services/background_service.dart';
import '../widgets/custom_fields.dart';
import '../theme/theme_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final UserModel? existingUserData;
  final bool isEditing;

  const RegistrationScreen({
    super.key,
    this.existingUserData,
    this.isEditing = false,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.existingUserData != null) {
      final user = widget.existingUserData!;
      _fName.text = user.fName;
      _lName.text = user.lName;
      _age.text = user.age;
      _email.text = user.email;
      _password.text = user.password;
      _confirmPassword.text = user.password;
      _bio.text = user.bio ?? '';
      _skills.text = user.skills;
      _hobbies.text = user.hobbies;
      _profileImageFile = user.localImage;
      _backgroundImageFile = user.localBackgroundImage;
    }
  }

  Future<void> _pickProfileImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _profileImageFile = file);
  }

  Future<void> _pickBackgroundImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _backgroundImageFile = file);
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 4) return 'Password must be at least 4 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _password.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _showSaveConfirmation() async {
    if (!_formKey.currentState!.validate()) return;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final palette = themeProvider.currentPalette;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: palette.primaryDark,
          title: const Text("Save Profile", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to save this profile?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: palette.primaryWash)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primaryLight,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

      if (widget.isEditing) {
        // UPDATE existing profile
        await Supabase.instance.client
            .from('profiles')
            .update({
              'first_name': _fName.text,
              'last_name': _lName.text,
              'age': int.parse(_age.text),
              'bio': _bio.text,
              'skills': _skills.text,
              'hobbies': _hobbies.text,
              'image_url': uploadedProfileUrl ?? widget.existingUserData?.imageUrl,
              'background_image_url': uploadedBackgroundUrl ?? widget.existingUserData?.backgroundImageUrl,
            })
            .eq('email', _email.text);
      } else {
        // CREATE new profile
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
      }

      if (!mounted) return;

      final settings = await BackgroundService.fetchUserBackgroundSettings(_email.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userData: UserModel(
              fName: _fName.text,
              lName: _lName.text,
              age: _age.text,
              email: _email.text,
              password: _password.text,
              bio: _bio.text,
              skills: _skills.text,
              hobbies: _hobbies.text,
              imageUrl: uploadedProfileUrl ?? widget.existingUserData?.imageUrl,
              localImage: _profileImageFile,
              backgroundImageUrl: uploadedBackgroundUrl ?? widget.existingUserData?.backgroundImageUrl,
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
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.currentPalette;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.primaryDark.withOpacity(0.5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.isEditing ? "Edit Profile" : "Create Profile",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  Text(
                    widget.isEditing ? "Edit Profile" : "Create Profile",
                    style: const TextStyle(
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
                                  border: Border.all(color: Colors.white, width: 4),
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
                                      ? (kIsWeb
                                          ? NetworkImage(_profileImageFile!.path)
                                          : FileImage(File(_profileImageFile!.path)) as ImageProvider)
                                      : null,
                                  child: _profileImageFile == null
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.camera_alt, size: 30, color: Colors.white70),
                                            SizedBox(height: 5),
                                            Text("Add Photo", style: TextStyle(fontSize: 11, color: Colors.white70)),
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
                                    child: const Icon(Icons.edit, size: 18, color: Colors.white),
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
                    Expanded(child: CustomTextField(label: "First Name", controller: _fName, palette: palette)),
                    const SizedBox(width: 15),
                    Expanded(child: CustomTextField(label: "Last Name", controller: _lName, palette: palette)),
                  ]),
                  const SizedBox(height: 15),

                  Row(children: [
                    SizedBox(width: 80, child: CustomTextField(label: "Age", controller: _age, palette: palette, isNum: true)),
                    const SizedBox(width: 15),
                    Expanded(child: CustomTextField(label: "Email", controller: _email, palette: palette, isEmail: true, isRequired: !widget.isEditing)),
                  ]),
                  const SizedBox(height: 15),

                  if (!widget.isEditing) ...[
                    PasswordField(
                      label: 'Password',
                      controller: _password,
                      palette: palette,
                      obscureText: _obscurePassword,
                      onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 15),
                    PasswordField(
                      label: 'Confirm Password',
                      controller: _confirmPassword,
                      palette: palette,
                      obscureText: _obscureConfirmPassword,
                      onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 15),
                  ],

                  CustomTextField(label: "Bio", controller: _bio, palette: palette, lines: 3, isRequired: false),
                  const SizedBox(height: 15),
                  CustomTextField(label: "Skills", controller: _skills, palette: palette),
                  const SizedBox(height: 15),
                  CustomTextField(label: "Hobbies", controller: _hobbies, palette: palette),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              widget.isEditing ? "Update Profile" : "Save Details",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                    ),
                  ),

                  if (!widget.isEditing) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ", style: TextStyle(color: Colors.white70)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
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