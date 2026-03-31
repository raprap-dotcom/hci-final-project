import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/lessons/linear_algebra.dart';
import '../data/lessons/integral_calculus.dart';
import '../data/lessons/physics.dart';
import '../data/lessons/chemistry.dart';
import '../screens/lessons_list_screen.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 HEADER
          Text(
            "What would you like to learn today?",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 SUBJECT CARDS
          _subjectCard(
            context,
            title: "Linear Algebra",
            subtitle: "Matrices, vectors, spaces",
            color: const Color(0xFF6C8CD5),
            iconPath: "assets/icons/linear.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonsScreen(lessons: linearAlgebraLessons),
                ),
              );
            },
          ),

          _subjectCard(
            context,
            title: "Integral Calculus",
            subtitle: "Integration, areas",
            color: const Color(0xFF8E7DBE),
            iconPath: "assets/icons/calculus.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LessonsScreen(lessons: integralCalculusLessons),
                ),
              );
            },
          ),

          _subjectCard(
            context,
            title: "Physics",
            subtitle: "Motion, energy, forces",
            color: const Color(0xFF5DA399),
            iconPath: "assets/icons/physics.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonsScreen(lessons: physicsLessons),
                ),
              );
            },
          ),

          _subjectCard(
            context,
            title: "Chemistry",
            subtitle: "Atoms, reactions",
            color: const Color(0xFFE07A5F),
            iconPath: "assets/icons/chemistry.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonsScreen(lessons: chemistryLessons),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _subjectCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // 🔹 ICON
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(iconPath),
                ),
              ),

              const SizedBox(width: 16),

              // 🔹 TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),

              // 🔹 ARROW
              const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
