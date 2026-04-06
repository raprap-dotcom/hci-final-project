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

class MainApp extends StatelessWidget {
  final bool startLoggedIn;

  const MainApp({super.key, required this.startLoggedIn});

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
          home: FutureBuilder<Map<String, bool>>(
            future: _loadStartupState(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                // Show loading spinner while checking storage
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

              return loggedIn ? const HomeScreen() : const LoginScreen();
            },
          ),
          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
            // '/login': (context) => const LoginWrapper(),
            // '/dragdrop': (context) => const DragAndDropTest(),
          },
        );
      },
    );
  }

  Future<Map<String, bool>> _loadStartupState() async {
    final seenOnboarding = await LocalStorage.hasSeenOnboarding();
    final loggedIn = await LocalStorage.isLoggedIn();

    return {'hasSeenOnboarding': seenOnboarding, 'loggedIn': loggedIn};
  }
}
