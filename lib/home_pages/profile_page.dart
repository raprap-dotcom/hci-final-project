import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../local_storage.dart';

class ProfilePage extends StatefulWidget {
  final List<String> avatars;
  final int selectedAvatar;
  final VoidCallback onChangeAvatar;
  final VoidCallback onLogout;
  final VoidCallback onOpenSettings;

  const ProfilePage({
    super.key,
    required this.avatars,
    required this.selectedAvatar,
    required this.onChangeAvatar,
    required this.onLogout,
    required this.onOpenSettings,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  int _level = 1;
  int _exp = 0;
  int _coins = 0;
  String _displayName = 'Guest';
  bool _loadingStats = true;

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  static const _gold = Color(0xFFC9960C);
  static const _goldLight = Color(0xFFF0C040);
  static const _ember = Color(0xFFE85D04);

  static const _blue = Color(0xFF395886);

  @override
  void initState() {
    super.initState();
    _loadStats();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final level = await LocalStorage.getLevel();
    final exp = await LocalStorage.getExp();
    final coins = await LocalStorage.getCoins();
    final username = await LocalStorage.getCurrentUsername();

    if (!mounted) return;

    setState(() {
      _level = level;
      _exp = exp;
      _coins = coins;
      _displayName = username ?? 'Guest';
      _loadingStats = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final currentLevelFloor = (_level - 1) * 100;
    final expInLevel = (_exp - currentLevelFloor).clamp(0, 100);
    final xpProgress = expInLevel / 100.0;

    return Container(
      color: colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        child: _loadingStats
            ? Center(
                child: CircularProgressIndicator(color: _goldLight),
              )
            : Column(
                children: [
                  _buildProfileCard(colors),
                  const SizedBox(height: 14),
                  _buildStatsRow(expInLevel, colors),
                  const SizedBox(height: 14),
                  _buildXpCard(xpProgress, expInLevel, colors),
                  const SizedBox(height: 14),
                  _buildAchievementCard(colors),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 18),
                  _buildActionButtons(colors),
                ],
              ),
      ),
    );
  }

  Widget _buildProfileCard(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surfaceVariant, colors.background],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _blue, width: 1.5),
      ),
      child: Row(
        children: [
          _buildAvatarRing(colors),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '⚔️  Arcane Warrior · Rank III',
                  style: GoogleFonts.crimsonText(
                    fontSize: 13,
                    color: colors.onSurface.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                _buildOutlineButton(
                  label: '✦  Change Avatar',
                  onPressed: widget.onChangeAvatar,
                  borderColor: _blue,
                  textColor: colors.onSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarRing(ColorScheme colors) {
    return Container(
      width: 88,
      height: 88,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [_gold, _ember, _goldLight, _gold],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.background,
        ),
        child: CircleAvatar(
          backgroundColor: colors.surface,
          backgroundImage: widget.avatars.isNotEmpty
              ? AssetImage(widget.avatars[widget.selectedAvatar])
              : null,
          child: widget.avatars.isEmpty
              ? const Text('🧙', style: TextStyle(fontSize: 36))
              : null,
        ),
      ),
    );
  }

  Widget _buildStatsRow(int expInLevel, ColorScheme colors) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCardImage(
            'assets/icons/level.png',
            'LEVEL',
            '$_level',
            colors,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCardImage(
            'assets/icons/gold.png',
            'GOLD',
            '$_coins',
            colors,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardImage(
      String imagePath, String label, String value, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surfaceVariant, colors.background],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _blue.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 28, height: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: colors.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpCard(
      double xpProgress, int expInLevel, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surfaceVariant, colors.background],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _blue.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚡ EXPERIENCE',
            style:
                TextStyle(color: colors.onSurface.withOpacity(0.7)),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: xpProgress,
            backgroundColor:
                colors.onSurface.withOpacity(0.1),
            valueColor:
                const AlwaysStoppedAnimation(_goldLight),
          ),
          const SizedBox(height: 6),
          Text(
            '$expInLevel / 100 XP',
            style:
                TextStyle(color: colors.onSurface.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surfaceVariant, colors.background],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _blue, width: 1.5),
      ),
      child: Row(
        children: [
          const Text('📜', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Complete your profile to claim your first reward.',
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colors) {
    return Column(
      children: [
        _buildOutlineButton(
          label: '⚙️ Settings',
          onPressed: widget.onOpenSettings,
          borderColor: _blue,
          textColor: colors.onSurface,
        ),
        const SizedBox(height: 10),
        _buildOutlineButton(
          label: '🚪 LOG OUT',
          onPressed: widget.onLogout,
          borderColor: Colors.red,
          textColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildOutlineButton({
    required String label,
    required VoidCallback onPressed,
    required Color borderColor,
    required Color textColor,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        foregroundColor: textColor,
      ),
      child: Text(label),
    );
  }
}