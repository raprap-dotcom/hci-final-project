import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/homepage.dart';
import 'package:hci_final_project/local_storage.dart';
import 'package:hci_final_project/progress_manager.dart';
import 'package:hci_final_project/quest_manager.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        await LocalStorage.createAccount(
          firstName: _usernameController.text.trim(),
          lastName: '',
          middleInitial: '',
          age: 0,
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
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
                    'Account Created!',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your account has been successfully created.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Username: ${_usernameController.text.trim()}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3E5C8A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: const Color(0xFF3E5C8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back to Login',
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

        if (!mounted) {
          return;
        }
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
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
    if (!mounted) {
      return;
    }
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('logo.png', height: 80),
                    const SizedBox(height: 10),
                    Text(
                      "MATHMASTER",
                      textAlign: TextAlign.center,
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
                    const SizedBox(height: 16),
                    Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Sign up to get started",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _fieldWrapper(
                      TextFormField(
                        controller: _usernameController,
                        decoration: _inputDecoration(
                          hint: 'Username',
                          icon: Icons.person_outline_rounded,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          if (value.contains(' ')) {
                            return 'Username cannot contain spaces';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    _fieldWrapper(
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration(
                          hint: 'Enter email',
                          icon: Icons.email_outlined,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%-]+$').hasMatch(value)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    _fieldWrapper(
                      TextFormField(
                        controller: _phoneController,
                        decoration: _inputDecoration(
                          hint: 'Enter phone number',
                          icon: Icons.phone_outlined,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          if (value.length < 10) {
                            return 'Phone number must be at least 10 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    _fieldWrapper(
                      TextFormField(
                        controller: _passwordController,
                        decoration: _inputDecoration(
                          hint: 'Enter a strong password',
                          icon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    _fieldWrapper(
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: _inputDecoration(
                          hint: 'Re-enter your password',
                          icon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    _hoverButton(
                      label: _isLoading
                          ? 'Creating Account...'
                          : 'Create Account',
                      onPressed: _isLoading ? () {} : _createAccount,
                      baseColor: const Color(0xFF3E5C8A),
                      hoverColor: const Color(0xFF2F4A74),
                      textColor: Colors.white,
                      hoverTextColor: Colors.white,
                      isLoading: _isLoading,
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
                            ).colorScheme.onSurface.withOpacity(0.6),
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
                          "Already have an account? ",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Login",
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
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    String? suffixText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      suffixText: suffixText,
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      suffixIcon: suffixIcon,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
      ),
    );
  }

  Widget _fieldWrapper(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: _glassCard(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: child,
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
                    ? baseColor.withOpacity(0.7)
                    : (isHovered ? hoverColor : baseColor),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: buttonBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
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
                                      textColor.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  label,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    letterSpacing: 0.4,
                                    fontWeight: FontWeight.w600,
                                    color: textColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              label,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                letterSpacing: 0.4,
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
