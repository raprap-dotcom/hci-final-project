import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../local_storage.dart';

class ProfilePage extends StatefulWidget {
  final List<String> avatars;
  final int selectedAvatar;
  final VoidCallback onChangeAvatar;
  final VoidCallback onLogout;
  final VoidCallback onOpenSettings;

  const ProfilePage({
    super.key,
    required this.avatars,
    required this.selectedAvatar,
    required this.onChangeAvatar,
    required this.onLogout,
    required this.onOpenSettings,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _level = 1;
  int _exp = 0;
  int _coins = 0;
  String _displayName = 'Guest';
  bool _loadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final level = await LocalStorage.getLevel();
    final exp = await LocalStorage.getExp();
    final coins = await LocalStorage.getCoins();
    final username = await LocalStorage.getCurrentUsername();

    if (!mounted) return;
    setState(() {
      _level = level;
      _exp = exp;
      _coins = coins;
      _displayName = username ?? 'Guest';
      _loadingStats = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLevelFloor = (_level - 1) * 100;
    final expInLevel = (_exp - currentLevelFloor).clamp(0, 100);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        child: Column(
          children: [
            // 🔹 Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      widget.avatars[widget.selectedAvatar],
                    ),
                  ),
                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 8),

                      ElevatedButton(
                        onPressed: widget.onChangeAvatar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text("Change Avatar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),

            // 🔹 Stats Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: _loadingStats
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Level: $_level',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Total EXP: $_exp',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Coins: $_coins',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: expInLevel / 100,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(999),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.12),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'EXP to next level: $expInLevel / 100',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
            ),

            Divider(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),

            // 🔹 Settings Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: widget.onOpenSettings,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  "Settings",
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // 🔹 Logout Button
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ElevatedButton(
                onPressed: widget.onLogout,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220, 50),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "LOG OUT",
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onError,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
