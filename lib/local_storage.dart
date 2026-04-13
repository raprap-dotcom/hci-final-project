import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyAccounts = 'accounts';
  static const _keyHasSeenOnboarding = 'hasSeenOnboarding';
  static const _keyBottomNavTutorialPrefix = 'hasSeenBottomNavTutorial';
  static const _keyCurrentUsername = 'currentUsername';
  static const _keyGuestExp = 'guestExp';
  static const _keyGuestCoins = 'guestCoins';
  static const _keyGuestLevel = 'guestLevel';
  static const _textScaleKey = 'text_scale';

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
    await prefs.remove(_keyCurrentUsername);
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
        'exp': 0,
        'coins': 0,
        'level': 1,
        'selectedAvatar': 0,
        'unlockedAvatars': [0],
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
      'exp': 0,
      'coins': 0,
      'level': 1,
      'selectedAvatar': 0,
      'unlockedAvatars': [0],
    });

    await prefs.setString(_keyAccounts, jsonEncode(accounts));
    await setLoggedIn(true);
    await setCurrentUsername(username);
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
      await setCurrentUsername(account['username'] as String);
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

  static Future<void> setCurrentUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrentUsername, username);
  }

  static Future<void> clearCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUsername);
  }

  static Future<String?> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentUsername);
  }

  static String _bottomNavTutorialKeyForUsername(String username) {
    return '$_keyBottomNavTutorialPrefix-$username';
  }

  static Future<bool> hasSeenBottomNavTutorialForCurrentUser() async {
    final username = await getCurrentUsername();
    if (username == null) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_bottomNavTutorialKeyForUsername(username)) ?? false;
  }

  static Future<void> setHasSeenBottomNavTutorialForCurrentUser(
    bool value,
  ) async {
    final username = await getCurrentUsername();
    if (username == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bottomNavTutorialKeyForUsername(username), value);
  }

  static Future<bool> shouldShowBottomNavTutorial() async {
    final username = await getCurrentUsername();

    if (username == null) {
      return true;
    }

    if (username == 'admin') {
      return false;
    }

    final seenTutorial = await hasSeenBottomNavTutorialForCurrentUser();
    return !seenTutorial;
  }

  static Future<Map<String, dynamic>?> getCurrentAccount() async {
    final username = await getCurrentUsername();
    if (username == null) return null;

    final accounts = await getAccounts();
    for (final account in accounts) {
      if (account['username'] == username) {
        return account;
      }
    }
    return null;
  }

  static Future<bool> _isGuestSession() async {
    final loggedIn = await isLoggedIn();
    if (!loggedIn) return false;
    final username = await getCurrentUsername();
    return username == null;
  }

  static int _calculateLevelFromExp(int exp) {
    return (exp ~/ 100) + 1;
  }

  static Future<List<Map<String, dynamic>>> _getAccountsCopy() async {
    final accounts = await getAccounts();
    return accounts.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<int?> _findCurrentAccountIndex(
    List<Map<String, dynamic>> accounts,
  ) async {
    final username = await getCurrentUsername();
    if (username == null) return null;

    for (var i = 0; i < accounts.length; i++) {
      if (accounts[i]['username'] == username) {
        return i;
      }
    }

    return null;
  }

  static Future<void> _saveAccounts(List<Map<String, dynamic>> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccounts, jsonEncode(accounts));
  }

  static Future<int> getExp() async {
    final account = await getCurrentAccount();
    if (account != null) {
      return (account['exp'] as int?) ?? 0;
    }

    if (await _isGuestSession()) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyGuestExp) ?? 0;
    }

    return 0;
  }

  static Future<void> setExp(int value) async {
    final accounts = await _getAccountsCopy();
    final index = await _findCurrentAccountIndex(accounts);
    final normalizedExp = value < 0 ? 0 : value;

    if (index == null) {
      if (await _isGuestSession()) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_keyGuestExp, normalizedExp);
        await prefs.setInt(
          _keyGuestLevel,
          _calculateLevelFromExp(normalizedExp),
        );
      }
      return;
    }

    accounts[index]['exp'] = normalizedExp;
    accounts[index]['level'] = _calculateLevelFromExp(normalizedExp);
    await _saveAccounts(accounts);
  }

  static Future<int> addExp(int value) async {
    final current = await getExp();
    final updated = current + value;
    await setExp(updated);
    return await getExp();
  }

  static Future<int> getCoins() async {
    final account = await getCurrentAccount();
    if (account != null) {
      return (account['coins'] as int?) ?? 0;
    }

    if (await _isGuestSession()) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyGuestCoins) ?? 0;
    }

    return 0;
  }

  static Future<void> setCoins(int value) async {
    final accounts = await _getAccountsCopy();
    final index = await _findCurrentAccountIndex(accounts);
    final normalizedCoins = value < 0 ? 0 : value;

    if (index == null) {
      if (await _isGuestSession()) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_keyGuestCoins, normalizedCoins);
      }
      return;
    }

    accounts[index]['coins'] = normalizedCoins;
    await _saveAccounts(accounts);
  }

  static Future<int> addCoins(int value) async {
    final current = await getCoins();
    final updated = current + value;
    await setCoins(updated);
    return await getCoins();
  }

  static Future<int> getLevel() async {
    final account = await getCurrentAccount();
    if (account != null) {
      final storedLevel = account['level'] as int?;
      if (storedLevel != null) return storedLevel;
    }

    if (await _isGuestSession()) {
      final prefs = await SharedPreferences.getInstance();
      final storedGuestLevel = prefs.getInt(_keyGuestLevel);
      if (storedGuestLevel != null) return storedGuestLevel;
    }

    final exp = await getExp();
    return _calculateLevelFromExp(exp);
  }

  static Future<void> setLevel(int value) async {
    final accounts = await _getAccountsCopy();
    final index = await _findCurrentAccountIndex(accounts);

    final normalizedLevel = value < 1 ? 1 : value;

    if (index == null) {
      if (await _isGuestSession()) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_keyGuestLevel, normalizedLevel);

        final minExpForLevel = (normalizedLevel - 1) * 100;
        final currentExp = prefs.getInt(_keyGuestExp) ?? 0;
        if (currentExp < minExpForLevel) {
          await prefs.setInt(_keyGuestExp, minExpForLevel);
        }
      }
      return;
    }

    accounts[index]['level'] = normalizedLevel;
    final minExpForLevel = (normalizedLevel - 1) * 100;
    final currentExp = (accounts[index]['exp'] as int?) ?? 0;
    if (currentExp < minExpForLevel) {
      accounts[index]['exp'] = minExpForLevel;
    }
    await _saveAccounts(accounts);
  }

  static Future<int> addLevel(int value) async {
    final current = await getLevel();
    final updated = current + value;
    await setLevel(updated);
    return await getLevel();
  }

  static List<int> _normalizeUnlocked(dynamic raw) {
    if (raw is List) {
      final values = raw
          .map((e) => e is num ? e.toInt() : int.tryParse(e.toString()))
          .whereType<int>()
          .toSet()
          .toList();
      if (!values.contains(0)) {
        values.add(0);
      }
      values.sort();
      return values;
    }
    return [0];
  }

  static Future<List<int>> getUnlockedAvatarIndices() async {
    final account = await getCurrentAccount();
    if (account == null) {
      return [0];
    }
    return _normalizeUnlocked(account['unlockedAvatars']);
  }

  static Future<bool> isAvatarUnlocked(int avatarIndex) async {
    final unlocked = await getUnlockedAvatarIndices();
    return unlocked.contains(avatarIndex);
  }

  static Future<void> unlockAvatar(int avatarIndex) async {
    final accounts = await _getAccountsCopy();
    final index = await _findCurrentAccountIndex(accounts);
    if (index == null) {
      return;
    }

    final unlocked = _normalizeUnlocked(accounts[index]['unlockedAvatars']);
    if (!unlocked.contains(avatarIndex)) {
      unlocked.add(avatarIndex);
      unlocked.sort();
      accounts[index]['unlockedAvatars'] = unlocked;
      await _saveAccounts(accounts);
    }
  }

  static Future<int> getSelectedAvatarIndex() async {
    final account = await getCurrentAccount();
    if (account == null) {
      return 0;
    }
    final unlocked = _normalizeUnlocked(account['unlockedAvatars']);
    final selected = (account['selectedAvatar'] as int?) ?? 0;
    if (!unlocked.contains(selected)) {
      return 0;
    }
    return selected;
  }

  static Future<void> setSelectedAvatarIndex(int avatarIndex) async {
    final accounts = await _getAccountsCopy();
    final index = await _findCurrentAccountIndex(accounts);
    if (index == null) {
      return;
    }

    final unlocked = _normalizeUnlocked(accounts[index]['unlockedAvatars']);
    if (!unlocked.contains(avatarIndex)) {
      return;
    }

    accounts[index]['selectedAvatar'] = avatarIndex;
    await _saveAccounts(accounts);
  }

  static Future<bool> spendCoins(int amount) async {
    if (amount <= 0) {
      return true;
    }
    final current = await getCoins();
    if (current < amount) {
      return false;
    }
    await setCoins(current - amount);
    return true;
  }
  
  static Future<void> setTextScale(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_textScaleKey, scale);
  }

  static Future<double?> getTextScale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_textScaleKey);
  }
}
