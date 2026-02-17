// Abandoned the old design, made a new design
import 'package:flutter/material.dart';

// 1. GLOBAL COLORS: Defined here so every class can see them
const Color sanJuan = Color(0xFF35556E);
const Color sanJuanDark = Color(0xFF2A4458); // Deeper shade for background
const Color sanJuanLight = Color(0xFF4A6F8A); // Lighter shade for accents
const Color sanJuanWash = Color(0xFF7694AD); // Desaturated shade

void main() {
  runApp(const SanJuanBentoApp());
}

class SanJuanBentoApp extends StatelessWidget {
  const SanJuanBentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // Using a deep version of the color as the background instead of gray/white
        scaffoldBackgroundColor: const Color(0xFF1E2F3D), 
      ),
      home: const AdaptiveBentoHome(),
    );
  }
}

class AdaptiveBentoHome extends StatelessWidget {
  const AdaptiveBentoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final bool isMobile = width < 700;
          
          double horizontalPadding = isMobile ? 16 : 60;
          double spacing = 16.0;
          double availableWidth = width - (horizontalPadding * 2);

          int columns = isMobile ? 2 : 4;
          double unitWidth = (availableWidth - (spacing * (columns - 1))) / columns;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 60),
            child: Center(
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  // 1. Hero Tile - Pure San Juan
                  BentoTile(
                    width: isMobile ? availableWidth : (unitWidth * 3) + (spacing * 2),
                    height: 300,
                    color: sanJuan,
                    child: _padding(
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("THINK. VISUALIZE. DESIGN. REPEAT", 
                            style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          SizedBox(height: 12),
                          Text("Hi! I'm Jonathan Mark", 
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500, height: 1.1, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),

                  // 2. Square - Muted / Darker shade
                  BentoTile(
                    width: isMobile ? (availableWidth - spacing) / 2 : unitWidth,
                    height: 300,
                    color: sanJuanDark,
                    child: Center(
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white10, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // 3. Status Tile - Semi-transparent version
                  BentoTile(
                    width: isMobile ? (availableWidth - spacing) / 2 : unitWidth,
                    height: 200,
                    color: sanJuan.withOpacity(0.4),
                    child: _padding(
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("This is for", style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text("Gallery?", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),

                  // 4. Project Preview - Gradient of Blue Shades
                  BentoTile(
                    width: isMobile ? availableWidth : (unitWidth * 2) + spacing,
                    height: 200,
                    gradient: const LinearGradient(
                      colors: [sanJuanLight, sanJuan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    child: _padding(
                      const Row(
                        children: [
                          Expanded(child: Text("PROJECTS", 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                          Text("→", style: TextStyle(color: Colors.white70, fontSize: 24)),
                        ],
                      ),
                    ),
                  ),

                  // 5. Contact - Desaturated Wash
                  BentoTile(
                    width: isMobile ? availableWidth : unitWidth,
                    height: 200,
                    color: sanJuanWash.withOpacity(0.5),
                    child: const Center(
                      child: Text("Contact", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _padding(Widget child) => Padding(padding: const EdgeInsets.all(32), child: child);
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
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.width,
        height: widget.height,
        curve: Curves.easeOutCubic,
        transform: isHovered ? (Matrix4.identity()..scale(1.01)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.color,
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              // Fix: sanJuan is now global, so this works perfectly!
              color: sanJuan.withOpacity(isHovered ? 0.3 : 0.1),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: widget.child,
        ),
      ),
    );
  }
}