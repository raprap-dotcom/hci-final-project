import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import 'package:hci_final_project/widgets/bottom_nav_bar.dart';
import 'package:hci_final_project/widgets/hover_scale.dart';
import 'local_storage.dart';
import 'package:hci_final_project/home_pages/profile_page.dart';
import 'package:hci_final_project/home_pages/subjects_page.dart';
import 'package:hci_final_project/home_pages/progress_page.dart';
import 'package:hci_final_project/home_pages/settings_page.dart';
import 'package:hci_final_project/home_pages/quests_page.dart';
import 'package:hci_final_project/home_pages/shop_page.dart';
import 'package:hci_final_project/home_pages/about_page.dart';
import 'package:hci_final_project/data/avatar_catalog.dart';
import 'package:hci_final_project/progress_manager.dart';

// Animated Trophy Widget
class _AnimatedAchievementTrophy extends StatelessWidget {
  const _AnimatedAchievementTrophy();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-22, 0),
      child: SizedBox(
        width: 200,
        height: 200,
        child: Lottie.asset(
          'assets/animations/achievements_trophy.json',
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}

class _SubjectPiePainter extends CustomPainter {
  final List<SubjectProgressData> subjects;
  final Map<String, Color> colors;

  _SubjectPiePainter(this.subjects, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final total = subjects.fold<double>(0, (sum, s) => sum + s.progress);

    if (total <= 0) {
      final paint = Paint()..color = const Color(0xFFCCD6E4);
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2, true, paint);
      return;
    }

    var startAngle = -math.pi / 2;
    for (final subject in subjects) {
      final sweep = (subject.progress / total) * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = colors[subject.subjectTitle] ?? const Color(0xFF9AA8BE);
      canvas.drawArc(rect, startAngle, sweep, true, paint);
      startAngle += sweep;
    }

    final holePaint = Paint()..color = const Color(0xFFF4F7FC);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.24,
      holePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SubjectPiePainter oldDelegate) {
    return oldDelegate.subjects != subjects || oldDelegate.colors != colors;
  }
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
  bool _showShopContent = false;
  bool _showAboutContent = false;
  bool _showBottomNavTutorial = false;
  bool _showBottomNavTutorialIntro = false;
  int _tutorialStepIndex = 0;

  final List<GlobalKey> _bottomNavItemKeys = List.generate(
    5,
    (_) => GlobalKey(),
  );

  final List<_BottomNavTutorialStep> _tutorialSteps = const [
    _BottomNavTutorialStep(
      navIndex: 0,
      title: 'Home',
      description: 'View your dashboard and daily learning summary.',
    ),
    _BottomNavTutorialStep(
      navIndex: 1,
      title: 'Progress',
      description: 'Track completed lessons and quiz performance.',
    ),
    _BottomNavTutorialStep(
      navIndex: 2,
      title: 'Subjects',
      description: 'Browse topics and start lessons by subject.',
    ),
    _BottomNavTutorialStep(
      navIndex: 3,
      title: 'Quests',
      description: 'Complete tasks to earn rewards and level up.',
    ),
    _BottomNavTutorialStep(
      navIndex: 4,
      title: 'Profile',
      description: 'Manage your account, avatar, and preferences.',
    ),
  ];

  int _selectedAvatar = 0;
  int animationKey = 0;

  List<String> get avatars =>
      avatarCatalog.map((item) => item.assetPath).toList();

  // Screens for each tab (you can replace later)
  List<Widget> get _pages => [
    Builder(builder: (context) => _homeContent(context)),
    const ProgressPage(),
    const SubjectsPage(),
    QuestsPage(
      onOpenShop: () {
        setState(() {
          _showHomeContent = false;
          _showSettingsContent = false;
          _showShopContent = true;
        });
      },
    ),
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
      _showShopContent = false;
      _showAboutContent = false;
    });
  }

  void _navigateFromDrawer({
    int? bottomNavIndex,
    bool showHome = false,
    bool showSettings = false,
    bool showShop = false,
    bool showAbout = false,
  }) {
    setState(() {
      _showHomeContent = showHome;
      _showSettingsContent = showSettings;
      _showShopContent = showShop;
      _showAboutContent = showAbout;
      if (bottomNavIndex != null) {
        _selectedIndex = bottomNavIndex;
      } else if (showHome || showSettings || showShop || showAbout) {
        _selectedIndex = 0;
      }
    });

    Navigator.of(context).pop();
  }

  String _getAppBarTitle() {
    if (_showSettingsContent) return 'Settings';
    if (_showShopContent) return 'Shop';
    if (_showAboutContent) return 'About';

    const titles = ['Home', 'Progress', 'Subjects', 'Quests', 'Profile'];
    return titles[_selectedIndex];
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
    Future<void>(() async {
      final currentLevel = await LocalStorage.getLevel();
      final unlocked = await LocalStorage.getUnlockedAvatarIndices();
      final isGuest = (await LocalStorage.getCurrentUsername()) == null;

      if (!mounted) {
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          int tempSelected = _selectedAvatar;

          return StatefulBuilder(
            builder: (context, setModalState) {
              return Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  width: 320,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
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

                        const SizedBox(height: 8),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: avatars.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            final item = avatarCatalog[index];
                            final isSelected = tempSelected == index;
                            final isUnlocked = unlocked.contains(index);
                            final meetsLevel =
                                currentLevel >= item.requiredLevel;
                            final isLocked = !isUnlocked;

                            return GestureDetector(
                              onTap: () {
                                if (isLocked) {
                                  final reason = !meetsLevel
                                      ? 'Level ${item.requiredLevel} required.'
                                      : isGuest
                                      ? 'Login required to unlock avatars.'
                                      : 'Unlock this avatar in Shop.';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(reason)),
                                  );
                                  return;
                                }
                                setModalState(() {
                                  tempSelected = index;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: isSelected
                                          ? Colors.blue
                                          : Colors.grey[300],
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundImage: AssetImage(
                                          avatars[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isLocked)
                                    SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.45),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await LocalStorage.setSelectedAvatarIndex(
                                  tempSelected,
                                );
                                setState(() {
                                  _selectedAvatar = tempSelected;
                                });
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  Future<void> _loadSelectedAvatar() async {
    final selected = await LocalStorage.getSelectedAvatarIndex();
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedAvatar = selected;
    });
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
    _loadSelectedAvatar();
    _maybeShowBottomNavTutorial();
  }

  Future<void> _maybeShowBottomNavTutorial() async {
    final shouldShow = await LocalStorage.shouldShowBottomNavTutorial();
    if (!mounted || !shouldShow) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _tutorialStepIndex = 0;
        _showBottomNavTutorialIntro = true;
        _showBottomNavTutorial = true;
      });
    });
  }

  Future<void> _finishBottomNavTutorial() async {
    await LocalStorage.setHasSeenBottomNavTutorialForCurrentUser(true);
    if (!mounted) {
      return;
    }
    setState(() {
      _showBottomNavTutorial = false;
      _showBottomNavTutorialIntro = false;
    });
  }

  void _startBottomNavTooltipSteps() {
    setState(() {
      _showBottomNavTutorialIntro = false;
      _tutorialStepIndex = 0;
    });
  }

  void _nextTutorialStep() {
    if (_tutorialStepIndex >= _tutorialSteps.length - 1) {
      _finishBottomNavTutorial();
      return;
    }

    setState(() {
      _tutorialStepIndex += 1;
    });
  }

  Rect? _getRectFromKey(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) {
      return null;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return null;
    }

    final offset = renderBox.localToGlobal(Offset.zero);
    return offset & renderBox.size;
  }

  double _resolveTooltipTargetCenterX({
    required _BottomNavTutorialStep step,
    required Rect? targetRect,
    required double fallbackCenterX,
  }) {
    if (targetRect == null) {
      return fallbackCenterX;
    }

    final isSelectedTab = _selectedIndex == step.navIndex;
    final isExpandedTab = targetRect.width > 58;
    if (isSelectedTab && isExpandedTab) {
      return targetRect.left + 22;
    }

    return targetRect.center.dx;
  }

  Widget _buildBottomNavTutorialOverlay() {
    if (_showBottomNavTutorialIntro) {
      return Positioned.fill(
        child: Material(
          color: Colors.black.withValues(alpha: 0.42),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's help you navigate",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2A3B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We will quickly walk through the 5 buttons in your bottom navigation bar.',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.35,
                          color: const Color(0xFF4B5566),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TextButton(
                            onPressed: _finishBottomNavTutorial,
                            child: const Text('Skip'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _startBottomNavTooltipSteps,
                            child: const Text('Start'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final insets = MediaQuery.of(context).padding;
    final step = _tutorialSteps[_tutorialStepIndex];
    final targetRect = _getRectFromKey(_bottomNavItemKeys[step.navIndex]);

    final fallbackSegmentWidth = size.width / _tutorialSteps.length;
    final fallbackCenterX =
        (fallbackSegmentWidth * step.navIndex) + (fallbackSegmentWidth / 2);

    final targetCenterX = _resolveTooltipTargetCenterX(
      step: step,
      targetRect: targetRect,
      fallbackCenterX: fallbackCenterX,
    );
    final targetCenterY =
        targetRect?.center.dy ??
        (size.height - insets.bottom - kBottomNavigationBarHeight / 2 - 14);

    const highlightSize = 58.0;
    final highlightLeft =
        targetCenterX.clamp(highlightSize / 2, size.width - highlightSize / 2) -
        highlightSize / 2;
    final highlightTop = targetCenterY - highlightSize / 2;

    final tooltipWidth = math.min(320.0, size.width * 0.86);
    final desiredTooltipLeft = targetCenterX - (tooltipWidth / 2);
    final tooltipLeft = desiredTooltipLeft.clamp(
      16.0,
      size.width - tooltipWidth - 16.0,
    );

    final desiredTooltipTop = highlightTop - 148;
    final tooltipTop = desiredTooltipTop.clamp(
      insets.top + 18,
      size.height - 220,
    );

    final isLastStep = _tutorialStepIndex == _tutorialSteps.length - 1;

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.42),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _nextTutorialStep,
                child: const SizedBox.expand(),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              left: highlightLeft,
              top: highlightTop,
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: highlightSize,
                  height: highlightSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.26),
                        blurRadius: 22,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              left: tooltipLeft,
              top: tooltipTop,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: tooltipWidth),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey(_tutorialStepIndex),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.14),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2A3B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.description,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            height: 1.3,
                            color: const Color(0xFF4B5566),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              '${_tutorialStepIndex + 1}/${_tutorialSteps.length}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF74839A),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: _finishBottomNavTutorial,
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF4B5566),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                              ),
                              child: const Text('Skip'),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: _nextTutorialStep,
                              child: Text(isLastStep ? 'Done' : 'Next'),
                            ),
                          ],
                        ),
                        Text(
                          'Tip: tap anywhere to continue',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF95A2B5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          drawer: Drawer(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: const Color(0xFFF2F6FC).withValues(alpha: 0.75),
                  child: Column(
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("logo.png", height: 60),
                            const SizedBox(height: 12),
                            Text(
                              "DASHBOARD",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF395886),
                              ),
                            ),
                          ],
                        ),
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
                        icon: Icons.task_alt_outlined,
                        label: "Quests",
                        onTap: () => _navigateFromDrawer(bottomNavIndex: 3),
                      ),
                      _buildDrawerItem(
                        icon: Icons.storefront_outlined,
                        label: "Shop",
                        onTap: () => _navigateFromDrawer(showShop: true),
                      ),
                      _buildDrawerItem(
                        icon: Icons.account_circle_outlined,
                        label: "Profile",
                        onTap: () => _navigateFromDrawer(bottomNavIndex: 4),
                      ),
                      _buildDrawerItem(
                        icon: Icons.settings_outlined,
                        label: "Settings",
                        onTap: () => _navigateFromDrawer(showSettings: true),
                      ),
                      _buildDrawerItem(
                        icon: Icons.info_outlined,
                        label: "About",
                        onTap: () => _navigateFromDrawer(showAbout: true),
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

          body: Column(
            children: [
              // Custom Header with Burger, Dashboard, and Dark Mode
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          _getAppBarTitle(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Transform.rotate(
                        angle: -0.35,
                        child: const Icon(Icons.nightlight_round),
                      ),
                      onPressed: () => themeController.toggle(),
                      style: IconButton.styleFrom(
                        shape: CircleBorder(
                          side: BorderSide(
                            color:
                                Theme.of(context).iconTheme.color ??
                                Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _showHomeContent
                    ? _homeContent(context)
                    : _showSettingsContent
                    ? SettingsPage(
                        onGoToSubjects: () {
                          setState(() {
                            _showHomeContent = false;
                            _showSettingsContent = false;
                            _showShopContent = false;
                            _showAboutContent = false;
                            _selectedIndex = 2; // Subjects index
                          });
                        },
                      )
                    : _showShopContent
                    ? ShopPage(
                        onAvatarEquipped: (avatarIndex) {
                          setState(() {
                            _selectedAvatar = avatarIndex;
                          });
                        },
                      )
                    : _showAboutContent
                    ? const AboutPage()
                    : _pages[_selectedIndex],
              ),
            ],
          ),

          bottomNavigationBar: MyBottomNavBar(
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
            navItemKeys: _bottomNavItemKeys,
          ),
        ),
        if (_showBottomNavTutorial) _buildBottomNavTutorialOverlay(),
      ],
    );
  }

  // Home Page
  Widget _homeContent(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDashboardData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final username = snapshot.data!['username'] as String;
        final progressSnapshot = snapshot.data!['snapshot'] as ProgressSnapshot;
        final subjects = progressSnapshot.subjects;
        final recentQuiz = progressSnapshot.recentQuiz;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $username',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Here is your learning snapshot.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 18),
              _buildAchievementsCard(),
              const SizedBox(height: 16),
              _buildPerformanceCard(subjects),
              const SizedBox(height: 16),
              _buildRecentQuizCard(recentQuiz),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final username = await LocalStorage.getCurrentUsername();
    final snapshot = await ProgressManager.getProgressSnapshot();
    return {'username': username ?? 'Guest', 'snapshot': snapshot};
  }

  Widget _buildPerformanceCard(List<SubjectProgressData> subjects) {
    final hasAnyProgress = subjects.any((s) => s.progress > 0);
    final chartData = hasAnyProgress
        ? subjects
        : subjects
              .map(
                (s) => SubjectProgressData(
                  subjectTitle: s.subjectTitle,
                  completedLessons: s.completedLessons,
                  totalLessons: s.totalLessons,
                  correctAnswers: s.correctAnswers,
                  totalQuestions: s.totalQuestions,
                  quizzesTaken: s.quizzesTaken,
                  progress: 0.25,
                ),
              )
              .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject Performance',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: CustomPaint(
                painter: _SubjectPiePainter(chartData, _subjectChartColors),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...subjects.map((subject) {
            final percent = (subject.progress * 100).toStringAsFixed(0);
            final color =
                _subjectChartColors[subject.subjectTitle] ??
                const Color(0xFF9AA8BE);

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      subject.subjectTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentQuizCard(QuizCompletionRecord? recentQuiz) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recently Completed Quiz',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          if (recentQuiz == null)
            Text(
              'No completed quizzes yet.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
          else ...[
            Text(
              recentQuiz.lessonTitle,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${recentQuiz.subjectTitle} • ${recentQuiz.correctAnswers}/${recentQuiz.totalQuestions} • ${recentQuiz.percentage}%',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementsCard() {
    const backgroundColor = Color(0xFF8AAEE0);
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedTextColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.7);

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to achievements page or show achievements dialog
      },
      child: HoverScale(
        hoverScale: 1.02,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Achievements',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'View your unlocked achievements',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: mutedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: _AnimatedAchievementTrophy(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'View all',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: mutedTextColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, Color> get _subjectChartColors => {
    'Linear Algebra': const Color(0xFFDA6EA8),
    'Integral Calculus': const Color(0xFF4EB39A),
    'Physics': const Color(0xFF9E8C68),
    'Chemistry': const Color(0xFFD8B84A),
  };

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    const drawerTextColor = Color(0xFF1F232B);
    const drawerIconColor = Color(0xFF395886);
    final hoverColor = drawerTextColor.withValues(alpha: 0.12);
    final splashColor = drawerTextColor.withValues(alpha: 0.16);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: hoverColor,
        splashColor: splashColor,
        child: ListTile(
          leading: Icon(icon, color: drawerIconColor),
          title: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: drawerTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavTutorialStep {
  final int navIndex;
  final String title;
  final String description;

  const _BottomNavTutorialStep({
    required this.navIndex,
    required this.title,
    required this.description,
  });
}
