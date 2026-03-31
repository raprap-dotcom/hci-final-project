import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/widgets/bottom_nav_bar.dart';
import 'local_storage.dart';
import 'package:hci_final_project/home_pages/profile_page.dart';
import 'package:hci_final_project/home_pages/subjects_page.dart';
import 'package:hci_final_project/home_pages/progress_page.dart';
import 'package:hci_final_project/home_pages/settings_page.dart';

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
      onLogout: () async {
        await LocalStorage.setLoggedIn(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
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
              onTap: () => _navigateFromDrawer(bottomNavIndex: 2),
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
              onTap: () => _navigateFromDrawer(bottomNavIndex: 3),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(context, "Subjects", const Color(0xFF395886), () {
            setState(() {
              _showHomeContent = false; // hide home
              _selectedIndex = 2; // show subjects tab
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
              MaterialPageRoute(
                builder: (context) => ProgressPage(
                  progressData: progressData,
                  onReset: () {
                    setState(() {
                      progressData.updateAll(
                        (key, value) => {"quiz": "0/0", "progress": 0.0},
                      );
                    });
                  },
                ),
              ),
            );
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
}
