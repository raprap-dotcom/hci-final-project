import 'package:flutter/material.dart';
import '../progress_manager.dart';
import '../widgets/hover_scale.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int animationKey = 0;
  bool _loading = true;
  List<SubjectProgressData> _subjectProgress = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.delayed(Duration.zero, () {
      setState(() {
        animationKey++;
      });
    });

    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final snapshot = await ProgressManager.getProgressSnapshot();
    if (!mounted) {
      return;
    }
    setState(() {
      _subjectProgress = snapshot.subjects;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 120 + bottomInset),
      child: Column(
        children: [
          ..._subjectProgress.asMap().entries.map((entry) {
            int index = entry.key;
            final data = entry.value;

            return _animatedCard(
              index,
              data.subjectTitle,
              data.quizLabel,
              data.progress,
            );
          }),

          const SizedBox(height: 20),

          HoverScale(
            child: ElevatedButton(
              onPressed: () => _confirmReset(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE41619),
                foregroundColor: Colors.white,
              ),
              child: const Text("Reset Progress"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset progress?"),
          content: const Text(
            "This will clear all progress. Do you want to continue?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE41619),
                foregroundColor: Colors.white,
              ),
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      await ProgressManager.resetProgress();
      await _loadProgress();
    }
  }

  // 🔥 CARD ANIMATION
  Widget _animatedCard(
    int index,
    String title,
    String quizzes,
    double progress,
  ) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(animationKey + index),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + (index * 200)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _buildCard(title, quizzes, progress),
    );
  }

  // 🔥 CARD UI
  Widget _buildCard(String title, String quizzes, double progress) {
    final cardColor = _cardColorForTitle(title);
    final iconPath = _iconPathForTitle(title);

    return HoverScale(
      hoverScale: 1.04,
      hoverShadows: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surfaceVariant
                : cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (iconPath != null)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(iconPath),
                    ),
                  ),
                if (iconPath != null) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "Quizzes Taken: $quizzes",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 12),

            // 🔥 PROGRESS BAR
            TweenAnimationBuilder<double>(
              key: ValueKey(animationKey),
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                Color barColor;

                if (value < 0.3) {
                  barColor = Colors.redAccent;
                } else if (value < 0.7) {
                  barColor = Colors.orange;
                } else {
                  barColor = Colors.green;
                }

                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 10,
                        backgroundColor:
                            Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                        color: barColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${(value * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 12),

            // 🏆 BADGE
            if (progress >= 0.4)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, _) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: Image.asset(
                        "assets/onboardingscreen/badge.png",
                        height: 40,
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

  Color _cardColorForTitle(String title) {
    switch (title) {
      case "Linear Algebra":
        return const Color(0xFFFBF0F7);
      case "Integral Calculus":
        return const Color(0xFFE2F2EF);
      case "Physics":
        return const Color(0xFFF3F1EC);
      case "Chemistry":
        return const Color(0xFFFAF1C2);
      default:
        return const Color(0xFFF2F6FC);
    }
  }

  String? _iconPathForTitle(String title) {
    switch (title) {
      case "Linear Algebra":
        return "assets/icons/linear.png";
      case "Integral Calculus":
        return "assets/icons/calculus.png";
      case "Physics":
        return "assets/icons/physics.png";
      case "Chemistry":
        return "assets/icons/chemistry.png";
      default:
        return null;
    }
  }
}
