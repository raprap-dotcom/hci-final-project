import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/widgets/bottom_nav_bar.dart';
import '../data/lessons/linear_algebra.dart';
import '../data/lessons/integral_calculus.dart';
import '../data/lessons/physics.dart';
import '../data/lessons/chemistry.dart';
import 'screens/lessons_list_screen.dart';
import 'local_storage.dart';
import 'progress_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showHomeContent = true;
  bool _showSettingsContent = false;

  int _selectedAvatar = 0;
  int animationKey = 0;

  final List<String> avatars = [
    "assets/avatars/brook.JPG",
    "assets/avatars/chopper.JPG",
    "assets/avatars/franky.JPG",
    "assets/avatars/jinbe.JPG",
    "assets/avatars/luffy.JPG",
    "assets/avatars/nami.JPG",
    "assets/avatars/robin.JPG",
    "assets/avatars/sanji.JPG",
    "assets/avatars/usopp.JPG",
    "assets/avatars/zoro.JPG",
  ];

  final Map<String, Map<String, dynamic>> progressData = {
    "Linear Algebra": {"quiz": "7/15", "progress": 0.4667},
    "Integral Calculus": {"quiz": "3/20", "progress": 0.15},
    "Physics": {"quiz": "1/20", "progress": 0.05},
    "Chemistry": {"quiz": "3/25", "progress": 0.12},
  };

  // Screens for each tab (you can replace later)
  List<Widget> get _pages => [
    Builder(builder: (context) => _homeContent(context)),
    const ProgressPage(),
    Builder(builder: (context) => _subjectsContent(context)),
    Builder(builder: (context) => _progressContent(context)),
    Builder(builder: (context) => _profileContent(context)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showHomeContent = false;
      _showSettingsContent = false;
    });
  }

  void _navigateFromDrawer({
    int? bottomNavIndex,
    bool showHome = false,
    bool showSettings = false,
  }) {
    setState(() {
      _showHomeContent = showHome;
      _showSettingsContent = showSettings;
      if (bottomNavIndex != null) {
        _selectedIndex = bottomNavIndex;
      }
    });

    Navigator.of(context).pop();
  }

  void _showAvatarPicker() {
    showDialog(
      context: context,
      builder: (context) {
        int tempSelected = _selectedAvatar;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Choose Avatar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),

                    const SizedBox(height: 10),

                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: avatars.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemBuilder: (context, index) {
                        final isSelected = tempSelected == index;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelected = index;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: isSelected
                                ? Colors.blue
                                : Colors.grey[300],
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: AssetImage(avatars[index]),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedAvatar = tempSelected;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
    // All pages use light blue background
    const bgColor = Color(0xFFE1ECF6);

    return Scaffold(
      extendBody: true,
      backgroundColor: bgColor,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF395886),
        title: Text(
          "MathMaster",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Image.asset("assets/logo.png"),
            ),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              iconColor: Colors.black,
              textColor: Colors.black,
              leading: const Icon(Icons.home_outlined),
              title: Text('Home', style: GoogleFonts.inter()),
              onTap: () => _navigateFromDrawer(showHome: true),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              iconColor: Colors.black,
              textColor: Colors.black,
              leading: const Icon(Icons.library_books_outlined),
              title: Text('Subjects', style: GoogleFonts.inter()),
              onTap: () => _navigateFromDrawer(bottomNavIndex: 0),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              iconColor: Colors.black,
              textColor: Colors.black,
              leading: const Icon(Icons.trending_up_outlined),
              title: Text('Progress', style: GoogleFonts.inter()),
              onTap: () => _navigateFromDrawer(bottomNavIndex: 1),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              iconColor: Colors.black,
              textColor: Colors.black,
              leading: const Icon(Icons.account_circle_outlined),
              title: Text('Profile', style: GoogleFonts.inter()),
              onTap: () => _navigateFromDrawer(bottomNavIndex: 2),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              iconColor: Colors.black,
              textColor: Colors.black,
              leading: const Icon(Icons.settings_outlined),
              title: Text('Settings', style: GoogleFonts.inter()),
              onTap: () => _navigateFromDrawer(showSettings: true),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              iconColor: Colors.black,
              textColor: Colors.black,
              leading: const Icon(Icons.info_outlined),
              title: Text('About', style: GoogleFonts.inter()),
              onTap: () {},
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              iconColor: Colors.black,
              textColor: Colors.black,
              leading: const Icon(Icons.exit_to_app_outlined),
              title: Text('Logout', style: GoogleFonts.inter()),
              onTap: () => _navigateFromDrawer(bottomNavIndex: 2),
            ),
          ],
        ),
      ),

      body: _showHomeContent
          ? _homeContent(context)
          : _showSettingsContent
          ? _settingsContent(context)
          : _pages[_selectedIndex],

      bottomNavigationBar: MyBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }

  // Home Page
  Widget _homeContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(context, "Subjects", const Color(0xFF395886), () {
            setState(() {
              _showHomeContent = false; // hide home
              _selectedIndex = 0; // show subjects tab
            });
          }),
          const SizedBox(height: 32),
          _buildButton(context, "Achievements", const Color(0xFF395886), () {
            print("Achievements pressed");
          }),
          const SizedBox(height: 32),
          _buildButton(context, "Progress", const Color(0xFF395886), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProgressPage()),
            );
          }),
        ],
      ),
    );
  }

  // 🔥 SUBJECTS PAGE (REPLACE YOUR OLD ONE)
  Widget _subjectsContent(BuildContext context) {
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
                  builder: (context) =>
                      LessonsScreen(lessons: linearAlgebraLessons),
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
                  builder: (context) =>
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
                  builder: (context) => LessonsScreen(lessons: physicsLessons),
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
                  builder: (context) =>
                      LessonsScreen(lessons: chemistryLessons),
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
            color: Colors.white.withOpacity(0.85), // keeps your bg visible
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

  // Progress Page
  Widget _progressContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
        ],
      ),
    );
  }

  // Profile Page
  Widget _profileContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(avatars[_selectedAvatar]),
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
                      onPressed: _showAvatarPicker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8AAEE0),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          // side: BorderSide(color: Colors.black, width: 2),
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
                SizedBox(height: 8),
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Color(0xFF8AAEE0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  // side: BorderSide(color: Colors.black, width: 2),
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
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              onPressed: () async {
                await LocalStorage.setLoggedIn(false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                backgroundColor: Color(0xFF8AAEE0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              icon: const Icon(Icons.exit_to_app_outlined, color: Colors.black),
              label: Text(
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

  // Settings Page
  Widget _settingsContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(context, "Subjects", const Color(0xFF395886), () {
            setState(() {
              _showHomeContent = false;
              _selectedIndex = 0;
            });
          }),
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
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF395886),
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Center(
          // <- ensures text is centered
          child: Text(
            text,
            textAlign: TextAlign.center, // <- extra safety
            style: GoogleFonts.poppins(
              fontSize: 26,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ],
            ),
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
