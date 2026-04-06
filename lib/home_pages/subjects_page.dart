import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/lessons/linear_algebra.dart';
import '../data/lessons/integral_calculus.dart';
import '../data/lessons/physics.dart';
import '../data/lessons/chemistry.dart';
import '../screens/lessons_list_screen.dart';
import '../widgets/hover_scale.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 180, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(context),
            const SizedBox(height: 16),
            _courseCard(
              context,
              title: "Linear Algebra",
              subtitle: "Matrices, vectors, spaces",
              meta: "+9 lessons",
              chipLabel: "Linear Algebra",
              color: const Color(0xFFFBF0F7),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonsScreen(
                      lessons: linearAlgebraLessons,
                      themeColor: const Color(0xFFFBF0F7),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _courseCard(
              context,
              title: "Chemistry",
              subtitle: "Atoms, reactions",
              meta: "+2 lessons",
              chipLabel: "Chemistry",
              color: const Color(0xFFFAF1C2),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonsScreen(
                      lessons: chemistryLessons,
                      themeColor: const Color(0xFFFAF1C2),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _courseCard(
              context,
              title: "Integral Calculus",
              subtitle: "Integration, areas",
              meta: "+2 lessons",
              chipLabel: "Calculus",
              color: const Color(0xFFE2F2EF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonsScreen(
                      lessons: integralCalculusLessons,
                      themeColor: const Color(0xFFE2F2EF),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _courseCard(
              context,
              title: "Physics",
              subtitle: "Motion, energy, forces",
              meta: "+2 lessons",
              chipLabel: "Physics",
              color: const Color(0xFFF3F1EC),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonsScreen(
                      lessons: physicsLessons,
                      themeColor: const Color(0xFFF3F1EC),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFC37A), Color(0xFFF09C63)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My courses",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF352A1D),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _statChip("4 subjects"),
                    const SizedBox(width: 8),
                    _statChip("15 lessons"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF272932),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _courseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String meta,
    required String chipLabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    final useDarkText = color.computeLuminance() > 0.7;
    final textColor = useDarkText ? const Color(0xFF1F232B) : Colors.white;
    final mutedTextColor =
        useDarkText ? const Color(0xFF3A3F4B) : Colors.white.withOpacity(0.75);

    return GestureDetector(
      onTap: onTap,
      child: HoverScale(
        hoverScale: 1.02,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: useDarkText
                          ? Colors.white.withOpacity(0.7)
                          : Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chipLabel.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: useDarkText
                            ? const Color(0xFF1F232B)
                            : Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: mutedTextColor,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meta,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: mutedTextColor,
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF1F232B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
