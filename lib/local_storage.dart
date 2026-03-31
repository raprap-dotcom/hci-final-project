import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyAccounts = 'accounts';
  static const _keyHasSeenOnboarding = 'hasSeenOnboarding';

  // Save login state
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  // Load login state
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenOnboarding, value);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  // Reset login state (for testing / logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // Initialize with admin account if accounts list is empty
  static Future<void> initAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyAccounts)) {
      final adminAccount = {
        'firstName': 'Admin',
        'lastName': '',
        'middleInitial': '',
        'age': 0,
        'phone': '',
        'email': '',
        'username': 'admin',
        'password': 'admin',
      };
      final accounts = [adminAccount];
      await prefs.setString(_keyAccounts, jsonEncode(accounts));
    }
  }

  // Create a new account
  static Future<void> createAccount({
    required String firstName,
    required String lastName,
    String middleInitial = '',
    required int age,
    required String phone,
    required String email,
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List accounts = [];

    if (prefs.containsKey(_keyAccounts)) {
      accounts = jsonDecode(prefs.getString(_keyAccounts)!) as List;
    }

    // Check if username already exists
    bool exists = accounts.any((acc) => acc['username'] == username);
    if (exists) throw Exception('Username already exists');

    // Add new account
    accounts.add({
      'firstName': firstName,
      'lastName': lastName,
      'middleInitial': middleInitial,
      'age': age,
      'phone': phone,
      'email': email,
      'username': username,
      'password': password,
    });

    await prefs.setString(_keyAccounts, jsonEncode(accounts));
    await setLoggedIn(true);
  }

  // Login with username and password
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyAccounts)) return false;

    final accounts = jsonDecode(prefs.getString(_keyAccounts)!) as List;
    final account = accounts.firstWhere(
      (acc) => acc['username'] == username && acc['password'] == password,
      orElse: () => null,
    );

    if (account != null) {
      await setLoggedIn(true);
      return true;
    }

    return false;
  }

  // Get all accounts (optional, for admin panel)
  static Future<List<Map<String, dynamic>>> getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_keyAccounts)) return [];
    final accounts = jsonDecode(prefs.getString(_keyAccounts)!) as List;
    return List<Map<String, dynamic>>.from(accounts);
  }
}
