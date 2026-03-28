import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/login_wrapper.dart';

// ==========================================
// 1. DATA (THE CONTENT OF YOUR SCREENS)
// ==========================================
class OnboardingContent {
  String title;
  String description;
  String imagePath; // Expects a String for the file path

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// 📝 EDIT TEXT AND IMAGES HERE:
// Make sure these file names match the actual .png files in your assets/onboardingscreen/ folder.
List<OnboardingContent> contents = [
  OnboardingContent(
    title: 'Welcome!',
    description: 'Math just met its match. Learn math the smart way.',
    imagePath: 'assets/onboardingscreen/welcome.png',
  ),
  OnboardingContent(
    title: 'Explore Multiple Subjects',
    description:
        'Go beyond basic math. Master Linear Algebra, Integral Calculus, Physics, and Chemistry all in one place.',
    imagePath: 'assets/onboardingscreen/subject.png',
  ),
  OnboardingContent(
    title: 'Challenge Your Skills',
    description:
        'Test your knowledge with curated quizzes tailored to your skill level, from Easy to Hard.',
    imagePath: 'assets/onboardingscreen/exam.png',
  ),
  OnboardingContent(
    title: 'Earn Epic Badges',
    description:
        'Turn studying into a game. Unlock unique achievements like "Integration Specialist" as you conquer complex topics.',
    imagePath: 'assets/onboardingscreen/badge.png',
  ),
  OnboardingContent(
    title: 'Track Your Growth',
    description:
        'Monitor your quiz scores, see your completion rates, and watch your mastery grow over time.',
    imagePath: 'assets/onboardingscreen/track.png',
  ),
  OnboardingContent(
    title: 'Study Your Way',
    description:
        'Create an account to save your milestones across devices, or dive right in as a guest to start learning immediately.',
    imagePath: 'assets/onboardingscreen/maths.png',
  ),
];

// ==========================================
// 2. THE SCREEN UI & BEHAVIOR
// ==========================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // This variable remembers which page the user is currently looking at (0 to 4).
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // HCI Principle: System Feedback.
  // We build little animated dots to show the user exactly where they are.
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 10,
      // If this dot matches the current screen, make it wider!
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // Color of the active vs inactive dots
        color: currentIndex == index
            ? Color(0xFF395886)
            : Colors
                  .grey
                  .shade400, // Darkened slightly for better visibility on the new background
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the blank canvas for our screen.
    return Scaffold(
      backgroundColor: const Color(0xFFBFC7D1),

      // SafeArea keeps our design from hiding behind the phone's camera notch.
      body: SafeArea(
        child: Column(
          children: [
            // The PageView lets the user swipe horizontally.
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  // When the user swipes, update our currentIndex variable.
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🖼️ Displays your custom PNG assets
                        Image.asset(
                          contents[i].imagePath,
                          height: 250,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 40),

                        // TITLE TEXT
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // DESCRIPTION TEXT
                        Text(
                          contents[i].description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ==========================================
            // 3. BOTTOM BUTTONS (SKIP, DOTS, NEXT)
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // HCI Principle: User Control. Let the user skip if they want to.
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(contents.length - 1);
                    },
                    child: const Text(
                      "SKIP",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),

                  // Shows the dots we built earlier
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (index) => buildDot(index, context),
                    ),
                  ),

                  // The main Call to Action button (NEXT / START)
                  ElevatedButton(
                    onPressed: () {
                      if (currentIndex == contents.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else {
                        // Animate to the next screen smoothly
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF395886),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      currentIndex == contents.length - 1 ? "START" : "NEXT",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
