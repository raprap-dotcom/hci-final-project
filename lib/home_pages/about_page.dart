import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF395886), Color(0xFF5A7BA8)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "MathMaster",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Version 1.0.0",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(context, "About MathMaster"),
          const SizedBox(height: 12),
          Text(
            "MathMaster is an interactive learning platform designed to make education engaging and fun. Through gamified quizzes, progress tracking, and interactive lessons, we transform the way students learn mathematics and sciences.",
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 28),
          _buildSectionTitle(context, "Key Features"),
          const SizedBox(height: 12),
          _buildFeatureItem(
            context,
            icon: Icons.quiz_rounded,
            title: "Interactive Quizzes",
            description: "Test your knowledge with engaging quiz questions",
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            context,
            icon: Icons.trending_up_rounded,
            title: "Progress Tracking",
            description: "Monitor your learning journey with detailed analytics",
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            context,
            icon: Icons.book_rounded,
            title: "Comprehensive Lessons",
            description: "Learn from structured and well-organized content",
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            context,
            icon: Icons.emoji_events_rounded,
            title: "Gamification",
            description: "Earn rewards, level up, and unlock new avatars",
          ),
          const SizedBox(height: 28),
          _buildSectionTitle(context, "Developed By"),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Zyrene Education Team",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Creating innovative solutions for interactive learning.",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _buildSectionTitle(context, "Support"),
          const SizedBox(height: 12),
          _buildLinkItem(
            context,
            icon: Icons.email_rounded,
            title: "Contact Us",
            subtitle: "support@zyrene.com",
          ),
          const SizedBox(height: 12),
          _buildLinkItem(
            context,
            icon: Icons.security_rounded,
            title: "Privacy Policy",
            subtitle: "Learn how we protect your data",
          ),
          const SizedBox(height: 12),
          _buildLinkItem(
            context,
            icon: Icons.description_rounded,
            title: "Terms of Service",
            subtitle: "Read our terms and conditions",
          ),
          const SizedBox(height: 28),
          Center(
            child: Column(
              children: [
                Text(
                  "© 2024 Zyrene Education",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "All rights reserved",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  static Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildLinkItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            size: 20,
          ),
        ],
      ),
    );
  }
}
