import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import '../models/color_palette.dart';
import '../models/user_model.dart';
import '../theme/theme_provider.dart';

class FriendsPopup extends StatefulWidget {
  final UserModel userData;

  const FriendsPopup({
    super.key,
    required this.userData,
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
          .select(
              'first_name, last_name, age, email, bio, skills, hobbies, image_url, background_image_url, background_type, background_value, glass_opacity, glass_blur')
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
    try {
      await supabase.from('friendships').upsert([
        {'user_email': widget.userData.email, 'friend_email': friendEmail},
        {'user_email': friendEmail, 'friend_email': widget.userData.email}
      ]);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Friend Added!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error adding friend: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewProfile(Map<String, dynamic> user) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final palette = themeProvider.currentPalette;
    
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
                  backgroundImage: user['image_url'] != null
                      ? NetworkImage(user['image_url'])
                      : null,
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
                  style: TextStyle(
                    color: palette.primaryWash,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (user['bio'] != null && user['bio'].toString().isNotEmpty) ...[
                const Text(
                  "BIO",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user['bio'],
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "SKILLS",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        const Text(
                          "PASSIONS",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                    Icon(
                      Icons.alternate_email,
                      color: palette.primaryWash,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user['email'] ?? 'No email',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.currentPalette;

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
                const Text(
                  "Friends",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
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
                  : _results.isEmpty
                      ? Center(
                          child: Text(
                            _results.isEmpty && _searchUsers is String
                                ? "No users found"
                                : "Search for friends",
                            style: TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final user = _results[index];
                            if (user['email'] == widget.userData.email) {
                              return const SizedBox.shrink();
                            }
                            return Card(
                              color: Colors.transparent,
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: InkWell(
                                onTap: () => _viewProfile(user),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            user['image_url'] != null
                                                ? NetworkImage(user['image_url'])
                                                : null,
                                        backgroundColor: Colors.white10,
                                        child: user['image_url'] == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white54,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${user['first_name']} ${user['last_name']}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (user['skills'] != null)
                                              Text(
                                                user['skills'],
                                                style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 12,
                                                ),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                        onPressed: () => _addFriend(user['email']),
                                        child: const Text(
                                          "Add",
                                          style: TextStyle(fontSize: 12),
                                        ),
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