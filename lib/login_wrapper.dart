import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/homepage.dart';
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
  String _errorMessage = '';

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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

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

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  void _guestLogin() async {
    await LocalStorage.setLoggedIn(true);
    await LocalStorage.clearCurrentUsername();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
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
                    icon: Icons.mail_outline_rounded,
                    hint: "Email",
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    icon: Icons.lock_outline,
                    hint: "Password",
                    obscure: true,
                    controller: _passwordController,
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
                    onPressed: _login,
                    baseColor: const Color(0xFF3E5C8A),
                    hoverColor: const Color(0xFF2F4A74),
                    textColor: Colors.white,
                    hoverTextColor: Colors.white,
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
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
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
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
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
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _glassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: TextField(
          controller: controller,
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
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.55),
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
                color: isHovered ? hoverColor : baseColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: buttonBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isHovered ? 0.2 : 0.12),
                    blurRadius: isHovered ? 18 : 12,
                    offset: Offset(0, isHovered ? 10 : 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: onPressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Center(
                      child: Text(
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
            color: Colors.black.withOpacity(hovered ? 0.18 : 0.12),
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
              color: baseTint.withOpacity(hovered ? 0.28 : 0.22),
              border: Border.all(
                color: baseBorder.withOpacity(hovered ? 0.7 : 0.45),
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
