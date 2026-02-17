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
  final VoidCallback? onRefresh;

  const AppSidebar({super.key, this.userData, this.onRefresh});

  // RESTORED: About Popup
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
                    title: const Text("Friends"), // Renamed
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

// --- 4. FRIENDS POPUP (RESTORING CLICKABLE PROFILES) ---
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

  Future<void> _addFriend(String friendEmail) async {
    final supabase = Supabase.instance.client;
    await supabase.from('friendships').upsert([
      { 'user_email': widget.userData.email, 'friend_email': friendEmail },
      { 'user_email': friendEmail, 'friend_email': widget.userData.email }
    ]);
    if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Friend Added!")));
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
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final user = _results[index];
                      if (user['email'] == widget.userData.email) return const SizedBox.shrink();
                      // UPDATED: Clickable profile tile
                      return ListTile(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Viewing ${user['first_name']}'s profile...")));
                        },
                        leading: CircleAvatar(
                          backgroundImage: user['image_url'] != null ? NetworkImage(user['image_url']) : null,
                          child: user['image_url'] == null ? const Icon(Icons.person) : null,
                        ),
                        title: Text("${user['first_name']} ${user['last_name']}"),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: sanJuanLight),
                          onPressed: () => _addFriend(user['email']),
                          child: const Text("Add"),
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

// --- 5. REGISTRATION FORM (RESTORED BUTTON) ---
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

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      String? uploadedUrl;
      if (_imageFile != null) {
        final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final bytes = await _imageFile!.readAsBytes();
        await Supabase.instance.client.storage.from('avatars').uploadBinary('public/$fileName', bytes);
        uploadedUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl('public/$fileName');
      }
      
      await Supabase.instance.client.from('profiles').upsert({
        'first_name': _fName.text, 'last_name': _lName.text,
        'age': int.parse(_age.text), 'email': _email.text,
        'bio': _bio.text, 'skills': _skills.text, 'hobbies': _hobbies.text,
        'image_url': uploadedUrl,
      }, onConflict: 'email');

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
            decoration: BoxDecoration(color: const Color(0xFF2C3E50).withOpacity(0.5), borderRadius: BorderRadius.circular(28)),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("Create Profile", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  GestureDetector(onTap: _pick, child: CircleAvatar(radius: 50, backgroundImage: _imageFile != null ? (kIsWeb ? NetworkImage(_imageFile!.path) : FileImage(File(_imageFile!.path)) as ImageProvider) : null)),
                  const SizedBox(height: 30),
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
                  // RESTORED: Original Button Style
                  ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave, 
                    child: const Text("Save Details")
                  )
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
      decoration: InputDecoration(labelText: l, filled: true, fillColor: Colors.black12, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))
    );
  }
}

// --- 6. ADAPTIVE BENTO HOME (BASELINE V2 LAYOUT) ---
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
    final profiles = await supabase.from('profiles').select().inFilter('email', emails);
    return List<Map<String, dynamic>>.from(profiles);
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
                    height: 300, color: sanJuan,
                    child: Stack(
                      children: [
                        Positioned.fill(child: Align(alignment: Alignment.centerRight, child: (widget.userData.localImage != null || widget.userData.imageUrl != null) ? Image(image: widget.userData.localImage != null ? (kIsWeb ? NetworkImage(widget.userData.localImage!.path) : FileImage(File(widget.userData.localImage!.path)) as ImageProvider) : NetworkImage(widget.userData.imageUrl!), fit: BoxFit.cover, width: unitW * 2.3) : Container())),
                        Padding(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Text("PROFILE PREVIEW", style: TextStyle(color: Colors.white38, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text("${widget.userData.fName}\n${widget.userData.lName}", style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1.1)),
                          if (widget.userData.bio != null) Text(widget.userData.bio!, maxLines: 2, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ])),
                      ],
                    ),
                  ),
                  BentoTile(
                    width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                    height: 300, color: sanJuanDark,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("AGE", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(widget.userData.age, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900)),
                      const Text("YEARS OLD", style: TextStyle(color: Colors.white24, fontSize: 9)),
                    ]),
                  ),
                  BentoTile(
                    width: isMobile ? (totalAvailableWidth - spacing) / 2 : unitW,
                    height: 220, color: const Color(0xFF253A4D),
                    child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.bolt, color: sanJuanWash, size: 20),
                      const Spacer(),
                      const Text("SKILLS", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(widget.userData.skills, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ])),
                  ),
                  BentoTile(
                    width: isMobile ? totalAvailableWidth : (unitW * 2) + spacing,
                    height: 220, gradient: const LinearGradient(colors: [sanJuanLight, sanJuan]),
                    child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("PASSIONS", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(widget.userData.hobbies, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                    ])),
                  ),
                  BentoTile(
                    width: isMobile ? totalAvailableWidth : unitW,
                    height: 220, color: Colors.white.withOpacity(0.05),
                    child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.alternate_email, color: sanJuanWash, size: 24),
                      const SizedBox(height: 12),
                      Text(widget.userData.email, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ])),
                  ),
                  BentoTile(
                    width: totalAvailableWidth,
                    height: 220, color: Colors.white.withOpacity(0.03),
                    child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              return Column(children: [
                                CircleAvatar(radius: 32, backgroundImage: f['image_url'] != null ? NetworkImage(f['image_url']) : null),
                                const SizedBox(height: 8),
                                Text("${f['first_name']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ]);
                            },
                          );
                        },
                      )),
                    ])),
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
        decoration: BoxDecoration(color: widget.color, gradient: widget.gradient, borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
        child: ClipRRect(borderRadius: BorderRadius.circular(32), child: widget.child),
      ),
    );
  }
}