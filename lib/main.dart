import 'package:flutter/material.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import 'package:hci_final_project/onboardingscreen.dart';
import 'homepage.dart';
import 'local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool loggedIn = await LocalStorage.isLoggedIn();

  runApp(MainApp(startLoggedIn: loggedIn));
}

class MainApp extends StatefulWidget {
  final bool startLoggedIn;

  const MainApp({super.key, required this.startLoggedIn});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double _textScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadTextScale(); // ✅ LOAD SAVED VALUE
  }

  void _updateTextScale(double scale) async {
    setState(() {
      _textScale = scale;
    });

    await LocalStorage.setTextScale(scale); // ✅ SAVE VALUE
  }

  Future<void> _loadTextScale() async {
    final savedScale = await LocalStorage.getTextScale();
    if (savedScale != null) {
      setState(() {
        _textScale = savedScale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: mode,

          // ✅ GLOBAL TEXT SCALING
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(_textScale),
              ),
              child: child!,
            );
          },

          home: FutureBuilder<Map<String, bool>>(
            future: _loadStartupState(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final startupState = snapshot.data!;
              final hasSeenOnboarding =
                  startupState['hasSeenOnboarding'] ?? false;
              final loggedIn = startupState['loggedIn'] ?? false;

              if (!hasSeenOnboarding) {
                return const OnboardingScreen();
              }

              return loggedIn
                  ? HomeScreen(
                      onTextScaleChanged: _updateTextScale,
                    )
                  : const LoginScreen();
            },
          ),
        );
      },
    );
  }

  Future<Map<String, bool>> _loadStartupState() async {
    final seenOnboarding = await LocalStorage.hasSeenOnboarding();
    final loggedIn = await LocalStorage.isLoggedIn();

    return {
      'hasSeenOnboarding': seenOnboarding,
      'loggedIn': loggedIn,
    };
  }
}