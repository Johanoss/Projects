import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import '../models/color_palette.dart';
import '../models/user_model.dart';
import '../services/background_service.dart';
import '../widgets/custom_fields.dart';
import '../theme/theme_provider.dart';
import 'registration_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      
      final settings = await BackgroundService.fetchUserBackgroundSettings(_email.text);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
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
              backgroundType: settings['background_type'] ?? userData['background_type'] ?? 'color',
              backgroundValue: settings['background_value'] ?? userData['background_value'],
              glassOpacity: (settings['glass_opacity'] as num?)?.toDouble() ?? 
                           (userData['glass_opacity'] as num?)?.toDouble() ?? 0.3,
              glassBlur: (settings['glass_blur'] as num?)?.toDouble() ?? 
                         (userData['glass_blur'] as num?)?.toDouble() ?? 10,
              glassBorderOpacity: (settings['glass_border_opacity'] as num?)?.toDouble() ?? 
                                 (userData['glass_border_opacity'] as num?)?.toDouble() ?? 0.2,
              shadowOpacity: (settings['shadow_opacity'] as num?)?.toDouble() ?? 
                            (userData['shadow_opacity'] as num?)?.toDouble() ?? 0.3,
              shadowBlur: (settings['shadow_blur'] as num?)?.toDouble() ?? 
                          (userData['shadow_blur'] as num?)?.toDouble() ?? 20,
              shadowOffsetX: (settings['shadow_offset_x'] as num?)?.toDouble() ?? 
                             (userData['shadow_offset_x'] as num?)?.toDouble() ?? 0,
              shadowOffsetY: (settings['shadow_offset_y'] as num?)?.toDouble() ?? 
                             (userData['shadow_offset_y'] as num?)?.toDouble() ?? 10,
              shadowColor: settings['shadow_color'] ?? userData['shadow_color'],
            ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.currentPalette;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.primaryDark.withOpacity(0.5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Login",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Login to your account",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  
                  CustomTextField(
                    label: 'Email',
                    controller: _email,
                    palette: palette,
                    isEmail: true,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  PasswordField(
                    label: 'Password',
                    controller: _password,
                    palette: palette,
                    obscureText: _obscurePassword,
                    onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Password is required';
                      if (val.length < 4) return 'Password must be at least 4 characters';
                      return null;
                    },
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
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Colors.white70)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
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