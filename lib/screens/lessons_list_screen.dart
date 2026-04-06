import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import '../models/lesson.dart';
import 'quiz_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final Color? themeColor;

  const LessonDetailScreen({super.key, required this.lesson, this.themeColor});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int currentIndex = 0;

  void _nextSection() {
    if (currentIndex < widget.lesson.sections.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void _previousSection() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.lesson.sections[currentIndex];
    final isLast = currentIndex == widget.lesson.sections.length - 1;
    final themeColor = widget.themeColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final buttonBackground = isDark ? primary : (themeColor ?? primary);
    final buttonForeground =
      isDark ? Colors.white : Theme.of(context).colorScheme.onPrimary;
    final outlineForeground =
      isDark ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final outlineSideColor =
      isDark ? Colors.white : (themeColor ?? outlineForeground);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.lesson.title} (${currentIndex + 1}/${widget.lesson.sections.length})",
        ),
        actions: const [ThemeToggleButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (section.imagePath != null) ...[
                      Image.asset(
                        section.imagePath!,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(
                      section.content,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    if (section.message != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          section.message!,
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // NAVIGATION OR FINAL BUTTONS
            if (!isLast)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentIndex > 0 ? _previousSection : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackground,
                      foregroundColor: buttonForeground,
                    ),
                    child: const Text("Previous"),
                  ),
                  ElevatedButton(
                    onPressed: _nextSection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackground,
                      foregroundColor: buttonForeground,
                    ),
                    child: const Text("Next"),
                  ),
                ],
              )
            else
              Column(
                children: [
                  if (widget.lesson.quizProblems.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                problems: widget.lesson.quizProblems,
                                themeColor: themeColor,
                                lessonTitle: widget.lesson.title,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackground,
                          foregroundColor: buttonForeground,
                        ),
                        child: const Text("Take Quiz"),
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: outlineForeground,
                        side: BorderSide(
                            color: outlineSideColor,
                        ),
                      ),
                      child: const Text("Back to Lessons"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class LessonsScreen extends StatelessWidget {
  final List<Lesson> lessons;
  final Color? themeColor;

  const LessonsScreen({super.key, required this.lessons, this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lessons"),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surfaceVariant
                : themeColor,
            child: ListTile(
              leading: lesson.imagePath != null
                  ? Image.asset(
                      lesson.imagePath!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.menu_book_rounded, size: 32),
              title: Text(
                lesson.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                lesson.description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailScreen(
                      lesson: lesson,
                      themeColor: themeColor,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
