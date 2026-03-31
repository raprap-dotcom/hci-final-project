import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
                  backgroundImage: AssetImage(avatars[selectedAvatar]),
                ),
                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Yamato",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: onChangeAvatar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8AAEE0),
                        foregroundColor: Colors.black,
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

          const Divider(color: Colors.black),

          // 🔹 Stats Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• Quizzes Completed: 12",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "• Badges Earned: 5",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.black),

          // 🔹 Settings Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: onOpenSettings,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: const Color(0xFF8AAEE0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                "Settings",
                style: GoogleFonts.poppins(
                  color: Colors.black,
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
              onPressed: onLogout,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                backgroundColor: const Color(0xFF8AAEE0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                "LOG OUT",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
