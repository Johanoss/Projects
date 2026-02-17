import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'theme/theme_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final palette = themeProvider.currentPalette;
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bento Portfolio',
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
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}