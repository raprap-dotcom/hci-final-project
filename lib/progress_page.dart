import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int animationKey = 0;

  final Map<String, Map<String, dynamic>> progressData = {
    "Linear Algebra": {"quiz": "7/15", "progress": 0.4667},
    "Integral Calculus": {"quiz": "3/20", "progress": 0.15},
    "Physics": {"quiz": "1/20", "progress": 0.05},
    "Chemistry": {"quiz": "3/25", "progress": 0.12},
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔥 Replay animation every time page opens
    Future.delayed(Duration.zero, () {
      setState(() {
        animationKey++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1ECF6),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              ...progressData.entries.toList().asMap().entries.map((entry) {
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
                onPressed: () {
                  setState(() {
                    progressData.updateAll(
                      (key, value) => {"quiz": "0/0", "progress": 0.0},
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F8FB3),
                ),
                child: const Text("Reset Progress"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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
        color: const Color.fromARGB(255, 255, 255, 255),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 8),

          Text("Quizzes Taken: $quizzes"),

          const SizedBox(height: 12),

          // 🔥 ANIMATED PROGRESS BAR
          TweenAnimationBuilder<double>(
            key: ValueKey(animationKey),
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              Color barColor;
              String statusText;

              if (value < 0.3) {
                barColor = const Color(0xFFEF5350);
                statusText = "Starting";
              } else if (value < 0.5) {
                barColor = const Color(0xFFFFA726);
                statusText = "In Progress";
              } else if (value < 0.8) {
                barColor = const Color(0xFFFFEE58);
                statusText = "Good Progress";
              } else {
                barColor = const Color(0xFF66BB6A);
                statusText = "Excellent";
              }

              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: Colors.grey[300],
                      color: barColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${(value * 100).toStringAsFixed(1)}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12,
                              color: barColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: barColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: barColor.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 12),

          // 🏆 BADGE (SHOW AT 40%)
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
