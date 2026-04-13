import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/homepage.dart';
import 'package:hci_final_project/progress_manager.dart';
import 'package:hci_final_project/quest_manager.dart';
import 'package:hci_final_project/screens/createaccountscreen.dart';
import 'local_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = true;
  bool _isLoggingIn = false;
  String _errorMessage = '';
  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    // Fetch all accounts
    List<Map<String, dynamic>> accounts = await LocalStorage.getAccounts();

    // Auto-fill last created account if exists
    if (accounts.isNotEmpty) {
      final lastAccount = accounts.last;
      _usernameController.text = lastAccount['username'] ?? '';
      _passwordController.text = lastAccount['password'] ?? '';
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showLoginError(String message) {
    _errorTimer?.cancel();
    setState(() {
      _errorMessage = message;
    });

    _errorTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = '';
      });
    });
  }

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showLoginError('Please enter username and password');
      return;
    }

    setState(() {
      _isLoggingIn = true;
      _errorMessage = '';
    });

    try {
      // Simulate network delay for better UX
      await Future.delayed(const Duration(milliseconds: 1000));

      bool success = await LocalStorage.login(username, password);

      // Allow admin login
      if (!success && username == 'admin' && password == 'admin') {
        success = true;
        await LocalStorage.setLoggedIn(true);
        await LocalStorage.setCurrentUsername('admin');

        // Print all accounts in storage
        List<Map<String, dynamic>> accounts = await LocalStorage.getAccounts();
        print("===== ALL ACCOUNTS IN STORAGE =====");
        for (var account in accounts) {
          print(account);
        }
        print("==================================");
      }

      if (!mounted) return;

      if (success) {
        setState(() {
          _isLoggingIn = false;
        });

        // Show success confirmation dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Login Successful!',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome back, $username!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF3E5C8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              onTextScaleChanged: (scale) {
                                // TODO: handle global text scaling here
                                debugPrint("Text scale changed: $scale");
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Continue',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        setState(() {
          _isLoggingIn = false;
        });
        _showLoginError('Invalid username or password');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoggingIn = false;
      });
      _showLoginError('Login failed: ${e.toString()}');
    }
  }

  void _guestLogin() async {
    await LocalStorage.setLoggedIn(true);
    await LocalStorage.clearCurrentUsername();
    await QuestManager.resetGuestQuestState();
    await ProgressManager.resetGuestProgress();
    await LocalStorage.setExp(0);
    await LocalStorage.setCoins(0);
    await LocalStorage.setLevel(1);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          onTextScaleChanged: (scale) {
            // TODO: handle global text scaling here
            debugPrint("Text scale changed: $scale");
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
        child: Center(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 80),
                  const SizedBox(height: 10),
                  Text(
                    "MATHMASTER",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                      shadows: const [
                        Shadow(
                          blurRadius: 4,
                          offset: Offset(2, 2),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Master Math Today!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildTextField(
                    icon: Icons.person_outline,
                    hint: "Username",
                    controller: _usernameController,
                    enableInput: !_isLoggingIn,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    icon: Icons.lock_outline,
                    hint: "Password",
                    obscure: true,
                    controller: _passwordController,
                    enableInput: !_isLoggingIn,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        print("Forgot password");
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage,
                        style: GoogleFonts.inter(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),
                  _hoverButton(
                    label: "LOGIN",
                    onPressed: _isLoggingIn ? () {} : _login,
                    baseColor: const Color(0xFF3E5C8A),
                    hoverColor: const Color(0xFF2F4A74),
                    textColor: Colors.white,
                    hoverTextColor: Colors.white,
                    isLoading: _isLoggingIn,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Colors.black26, thickness: 1),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "or",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Divider(color: Colors.black26, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _hoverButton(
                    label: "Continue as Guest",
                    onPressed: _guestLogin,
                    baseColor: Colors.white,
                    hoverColor: const Color(0xFFE2E6EC),
                    textColor: const Color(0xFF1B2B45),
                    hoverTextColor: const Color(0xFF1B2B45),
                    borderColor: const Color(0xFF395886),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateAccountScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Register now",
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD14B4B),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool obscure = false,
    bool enableInput = true,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _glassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: TextField(
          controller: controller,
          enabled: enableInput,
          obscureText: obscure,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _hoverButton({
    required String label,
    required VoidCallback onPressed,
    required Color baseColor,
    required Color hoverColor,
    required Color textColor,
    required Color hoverTextColor,
    Color? borderColor,
    bool isLoading = false,
  }) {
    bool isHovered = false;
    final buttonBorder = borderColor ?? baseColor;
    return SizedBox(
      width: double.infinity,
      child: StatefulBuilder(
        builder: (context, setInnerState) {
          return MouseRegion(
            onEnter: (_) => setInnerState(() => isHovered = true),
            onExit: (_) => setInnerState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: isLoading
                    ? baseColor.withValues(alpha: 0.7)
                    : (isHovered ? hoverColor : baseColor),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: buttonBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 
                      isHovered && !isLoading ? 0.2 : 0.12,
                    ),
                    blurRadius: isHovered && !isLoading ? 18 : 12,
                    offset: Offset(0, isHovered && !isLoading ? 10 : 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: isLoading ? null : onPressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Center(
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      textColor.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Logging in...',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
                                    color: textColor.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              label,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: isHovered ? hoverTextColor : textColor,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _glassCard({
    required Widget child,
    EdgeInsets? padding,
    Color? tintColor,
    Color? borderColor,
    bool hovered = false,
  }) {
    const borderRadius = BorderRadius.all(Radius.circular(16));
    final baseTint = tintColor ?? Colors.white;
    final baseBorder = borderColor ?? Colors.white;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, hovered ? -2 : 0, 0),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: hovered ? 0.18 : 0.12),
            blurRadius: hovered ? 22 : 18,
            offset: Offset(0, hovered ? 12 : 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: baseTint.withValues(alpha: hovered ? 0.28 : 0.22),
              border: Border.all(
                color: baseBorder.withValues(alpha: hovered ? 0.7 : 0.45),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
