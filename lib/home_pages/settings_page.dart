import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback onGoToSubjects;

  const SettingsPage({super.key, required this.onGoToSubjects});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context,
            "Subjects",
            const Color(0xFF395886),
            onGoToSubjects,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 300,
      height: 95,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 26,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
