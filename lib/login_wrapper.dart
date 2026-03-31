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
        decoration: const BoxDecoration(color: Color(0xFFBFC7D1)),
        child: Center(
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
                  "Log In",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3E5C8A),
                  ),
                ),
                const Divider(thickness: 2, color: Color(0xFF3E5C8A)),
                const SizedBox(height: 15),

                _buildTextField(
                  icon: Icons.person_outline,
                  hint: "Username",
                  controller: _usernameController,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  icon: Icons.lock_outline,
                  hint: "Password",
                  obscure: true,
                  controller: _passwordController,
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

                const SizedBox(height: 25),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E5C8A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "LOG IN",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        print("Forgot password");
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.inter(
                          color: Colors.brown,
                          fontWeight: FontWeight.w500,
                        ),
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
                        "Create an account",
                        style: GoogleFonts.inter(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                OutlinedButton(
                  onPressed: _guestLogin,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF395886)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Continue as Guest",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
