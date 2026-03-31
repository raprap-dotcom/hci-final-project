import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  final Map<String, Map<String, dynamic>> progressData;
  final VoidCallback onReset;

  const ProgressPage({
    super.key,
    required this.progressData,
    required this.onReset,
  });

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int animationKey = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.delayed(Duration.zero, () {
      setState(() {
        animationKey++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 120 + bottomInset),
      child: Column(
        children: [
          ...widget.progressData.entries.toList().asMap().entries.map((entry) {
            int index = entry.key;
            var data = entry.value;

            return _animatedCard(
              index,
              data.key,
              data.value["quiz"],
              data.value["progress"],
            );
          }),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () => _confirmReset(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F8FB3),
            ),
            child: const Text("Reset Progress"),
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
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      widget.onReset();
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFD3D9E2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 8),

          Text("Quizzes Taken: $quizzes"),

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
                      backgroundColor: Colors.grey[300],
                      color: barColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${(value * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}