import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/avatar_catalog.dart';
import '../local_storage.dart';

class ShopPage extends StatefulWidget {
  final ValueChanged<int>? onAvatarEquipped;

  const ShopPage({super.key, this.onAvatarEquipped});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _level = 1;
  int _coins = 0;
  int _selectedAvatar = 0;
  List<int> _unlocked = const [0];
  bool _isGuest = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final username = await LocalStorage.getCurrentUsername();
    final isGuest = username == null;

    final level = await LocalStorage.getLevel();
    final coins = await LocalStorage.getCoins();
    final unlocked = await LocalStorage.getUnlockedAvatarIndices();
    final selectedAvatar = await LocalStorage.getSelectedAvatarIndex();

    if (!mounted) return;

    setState(() {
      _isGuest = isGuest;
      _level = level;
      _coins = coins;
      _unlocked = unlocked;
      _selectedAvatar = selectedAvatar;
      _loading = false;
    });
  }

  Future<void> _unlockAvatar(int index) async {
    if (_isGuest) {
      _showMessage('Guest accounts cannot unlock shop items.');
      return;
    }

    final item = avatarCatalog[index];
    if (_level < item.requiredLevel) {
      _showMessage('Reach level ${item.requiredLevel} to unlock ${item.name}.');
      return;
    }

    if (_coins < item.coinCost) {
      _showMessage('Not enough coins. You need ${item.coinCost} coins.');
      return;
    }

    final spent = await LocalStorage.spendCoins(item.coinCost);
    if (!spent) {
      _showMessage('Not enough coins.');
      return;
    }

    await LocalStorage.unlockAvatar(index);
    await _loadState();
    _showMessage('${item.name} unlocked.');
  }

  Future<void> _equipAvatar(int index) async {
    final isUnlocked = _unlocked.contains(index);
    if (!isUnlocked) {
      _showMessage('Unlock this avatar first.');
      return;
    }

    await LocalStorage.setSelectedAvatarIndex(index);
    if (!mounted) return;

    setState(() {
      _selectedAvatar = index;
    });
    widget.onAvatarEquipped?.call(index);
    _showMessage('${avatarCatalog[index].name} equipped.');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        Text(
          'Avatar Shop',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Spend coins earned from quests to unlock avatars.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _chip('Level $_level'),
            const SizedBox(width: 8),
            _chip('Coins $_coins'),
          ],
        ),
        if (_isGuest) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Text(
              'Login required: guest accounts cannot purchase or equip locked avatars.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        ...List.generate(avatarCatalog.length, _buildItem),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = avatarCatalog[index];
    final isUnlocked = _unlocked.contains(index);
    final isEquipped = _selectedAvatar == index;
    final meetsLevel = _level >= item.requiredLevel;

    String subtitle = 'Requires level ${item.requiredLevel}';
    if (isUnlocked) {
      subtitle = isEquipped ? 'Equipped' : 'Unlocked';
    } else {
      subtitle = 'Cost: ${item.coinCost} coins • Level ${item.requiredLevel}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(item.assetPath)),
        title: Text(
          item.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: isUnlocked
            ? ElevatedButton(
                onPressed: isEquipped ? null : () => _equipAvatar(index),
                child: Text(isEquipped ? 'Equipped' : 'Equip'),
              )
            : ElevatedButton(
                onPressed: meetsLevel ? () => _unlockAvatar(index) : null,
                child: const Text('Unlock'),
              ),
      ),
    );
  }
}
