import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/widgets/bottom_nav_bar.dart';
import 'package:hci_final_project/widgets/hover_scale.dart';
import 'package:hci_final_project/data/lessons/linear_algebra.dart';
import 'package:hci_final_project/data/lessons/integral_calculus.dart';
import 'package:hci_final_project/data/lessons/physics.dart';
import 'package:hci_final_project/data/lessons/chemistry.dart';
import 'package:hci_final_project/models/lesson.dart';
import 'local_storage.dart';
import 'package:hci_final_project/home_pages/profile_page.dart';
import 'package:hci_final_project/home_pages/subjects_page.dart';
import 'package:hci_final_project/home_pages/progress_page.dart';
import 'package:hci_final_project/home_pages/settings_page.dart';

class _SubjectMeta {
  final String title;
  final String subtitle;
  final String category;
  final Color color;
  final String iconPath;
  final List<Lesson> lessons;

  const _SubjectMeta({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.color,
    required this.iconPath,
    required this.lessons,
  });
}

class _AchievementMeta {
  final String title;
  final String iconPath;
  final String requirement;

  const _AchievementMeta({
    required this.title,
    required this.iconPath,
    required this.requirement,
  });
}

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
  TextEditingController? _searchController;
  String _selectedCategory = "All";

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

  final List<_SubjectMeta> _subjects = [
    _SubjectMeta(
      title: "Linear Algebra",
      subtitle: "Matrices, vectors, spaces",
      category: "Algebra",
      color: Color(0xFFFBF0F7),
      iconPath: "assets/icons/linear.png",
      lessons: linearAlgebraLessons,
    ),
    _SubjectMeta(
      title: "Integral Calculus",
      subtitle: "Integration, areas",
      category: "Calculus",
      color: Color(0xFFE2F2EF),
      iconPath: "assets/icons/calculus.png",
      lessons: integralCalculusLessons,
    ),
    _SubjectMeta(
      title: "Physics",
      subtitle: "Motion, energy, forces",
      category: "Physics",
      color: Color(0xFFF3F1EC),
      iconPath: "assets/icons/physics.png",
      lessons: physicsLessons,
    ),
    _SubjectMeta(
      title: "Chemistry",
      subtitle: "Atoms, reactions",
      category: "Chemistry",
      color: Color(0xFFFAF1C2),
      iconPath: "assets/icons/chemistry.png",
      lessons: chemistryLessons,
    ),
  ];

  final List<_AchievementMeta> _achievements = const [
    _AchievementMeta(
      title: "First Lesson",
      iconPath: "assets/onboardingscreen/badge.png",
      requirement: "Complete your first lesson.",
    ),
    _AchievementMeta(
      title: "Problem Solver",
      iconPath: "assets/onboardingscreen/badge.png",
      requirement: "Answer 10 quiz questions correctly.",
    ),
    _AchievementMeta(
      title: "Consistency",
      iconPath: "assets/onboardingscreen/badge.png",
      requirement: "Study 3 days in a row.",
    ),
    _AchievementMeta(
      title: "Science Explorer",
      iconPath: "assets/onboardingscreen/badge.png",
      requirement: "Finish a Physics lesson.",
    ),
  ];

  List<_SubjectMeta> get _filteredSubjects {
    _searchController ??= TextEditingController();
    final query = _searchController?.text.trim().toLowerCase() ?? "";

    return _subjects.where((subject) {
      final matchesCategory =
          _selectedCategory == "All" || subject.category == _selectedCategory;

      if (!matchesCategory) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }

      final inTitle = subject.title.toLowerCase().contains(query);
      final inSubtitle = subject.subtitle.toLowerCase().contains(query);
      final inLessons = subject.lessons.any(
        (lesson) => lesson.title.toLowerCase().contains(query),
      );

      return inTitle || inSubtitle || inLessons;
    }).toList();
  }

  // Screens for each tab (you can replace later)
  List<Widget> get _pages => [
    Builder(builder: (context) => _homeContent(context)),
    ProgressPage(
      progressData: progressData,
      onReset: () {
        setState(() {
          progressData.updateAll(
            (key, value) => {"quiz": "0/0", "progress": 0.0},
          );
        });
      },
    ),
    const SubjectsPage(),
    ProfilePage(
      avatars: avatars,
      selectedAvatar: _selectedAvatar,
      onChangeAvatar: _showAvatarPicker,
      onOpenSettings: () {
        setState(() {
          _showHomeContent = false;
          _showSettingsContent = true;
        });
      },
      onLogout: _confirmLogout,
    ),
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
      } else if (showHome || showSettings) {
        _selectedIndex = 0;
      }
    });

    Navigator.of(context).pop();
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Log out"),
          ),
        ],
      ),
    );

    if (shouldLogout != true) {
      return;
    }

    await LocalStorage.setLoggedIn(false);
    if (!mounted) {
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
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
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: const Color(0xFFF2F6FC).withOpacity(0.75),
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Image.asset("assets/logo.png"),
                  ),
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    label: "Home",
                    onTap: () => _navigateFromDrawer(showHome: true),
                  ),
                  _buildDrawerItem(
                    icon: Icons.library_books_outlined,
                    label: "Subjects",
                    onTap: () => _navigateFromDrawer(bottomNavIndex: 2),
                  ),
                  _buildDrawerItem(
                    icon: Icons.trending_up_outlined,
                    label: "Progress",
                    onTap: () => _navigateFromDrawer(bottomNavIndex: 1),
                  ),
                  _buildDrawerItem(
                    icon: Icons.account_circle_outlined,
                    label: "Profile",
                    onTap: () => _navigateFromDrawer(bottomNavIndex: 3),
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    label: "Settings",
                    onTap: () => _navigateFromDrawer(showSettings: true),
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outlined,
                    label: "About",
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.exit_to_app_outlined,
                    label: "Logout",
                    onTap: _confirmLogout,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: _showHomeContent
          ? _homeContent(context)
          : _showSettingsContent
          ? SettingsPage(
              onGoToSubjects: () {
                setState(() {
                  _showHomeContent = false;
                  _showSettingsContent = false;
                  _selectedIndex = 2; // Subjects index
                });
              },
            )
          : _pages[_selectedIndex],

      bottomNavigationBar: MyBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }

  // Home Page
  Widget _homeContent(BuildContext context) {
    final filteredSubjects = _filteredSubjects;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 HERO
          Text(
            "What would you like to learn today?",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Your daily dose of brain gains.",
            style: GoogleFonts.poppins(fontSize: 16),
          ),

          const SizedBox(height: 20),

          // 🔹 SEARCH
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Search topics...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 15),

          _achievementCard(),

          const SizedBox(height: 12),

          // 🔹 CHIPS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _categoryChip("All"),
                _categoryChip("Algebra"),
                _categoryChip("Calculus"),
                _categoryChip("Physics"),
                _categoryChip("Chemistry"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (filteredSubjects.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "No subjects match your search.",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),

          for (final subject in filteredSubjects) _subjectCard(subject),
        ],
      ),
    );
  }

  Widget _categoryChip(String text) {
    final isSelected = _selectedCategory == text;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        selected: isSelected,
        label: Text(text),
        onSelected: (_) {
          setState(() {
            _selectedCategory = text;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.grey[300],
        showCheckmark: false,
        labelStyle: TextStyle(
          color: Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),
    );
  }

  Widget _achievementCard() {
    return GestureDetector(
      onTap: _showAchievements,
      child: HoverScale(
        hoverScale: 1.03,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF395886),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/onboardingscreen/badge.png",
                width: 36,
                height: 36,
              ),
              const SizedBox(height: 8),
              Text(
                "Achievements",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievements() {
    showDialog(
      context: context,
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.7;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Achievements",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        tooltip: "Close",
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/onboardingscreen/badge.png",
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: Text(
                        "No achievements yet",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _subjectCard(_SubjectMeta subject) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _showSubjectOverview(subject),
        child: HoverScale(
          hoverScale: 1.04,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: subject.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(subject.iconPath),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject.subtitle,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSubjectOverview(_SubjectMeta subject) {
    showDialog(
      context: context,
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.7;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subject.title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        tooltip: "Close",
                      ),
                    ],
                  ),
                  Text(
                    subject.subtitle,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 6),
                  Text(
                    "Topics",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.separated(
                        itemCount: subject.lessons.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final lesson = subject.lessons[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.circle, size: 8),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  lesson.title,
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF395886)),
      title: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
