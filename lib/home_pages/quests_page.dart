import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../local_storage.dart';
import '../models/quest.dart';
import '../quest_manager.dart';

class QuestsPage extends StatefulWidget {
  final VoidCallback? onOpenShop;

  const QuestsPage({super.key, this.onOpenShop});

  @override
  State<QuestsPage> createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage> {
  List<Quest> _quests = const [];
  int _level = 1;
  int _exp = 0;
  int _coins = 0;
  bool _isGuest = false;
  bool _loading = true;
  Duration _timeUntilReset = Duration.zero;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _timeUntilReset = _calculateTimeUntilNextReset();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _timeUntilReset = _calculateTimeUntilNextReset();
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Duration _calculateTimeUntilNextReset() {
    final now = DateTime.now();
    final nextReset = DateTime(now.year, now.month, now.day + 1);
    return nextReset.difference(now);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> _loadData() async {
    final quests = await QuestManager.getDailyQuests();
    final level = await LocalStorage.getLevel();
    final exp = await LocalStorage.getExp();
    final coins = await LocalStorage.getCoins();
    final username = await LocalStorage.getCurrentUsername();

    if (!mounted) return;

    setState(() {
      _quests = quests;
      _level = level;
      _exp = exp;
      _coins = coins;
      _isGuest = username == null;
      _loading = false;
    });
  }

  int get _completedCount {
    return _quests.where((q) => q.isCompleted).length;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final progressBase = (_level - 1) * 100;
    final progressCurrent = (_exp - progressBase).clamp(0, 100);
    const progressMax = 100;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          Text(
            'Daily Quests',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Complete quests by finishing lesson quizzes.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          if (widget.onOpenShop != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: widget.onOpenShop,
                icon: const Icon(Icons.storefront_outlined),
                label: const Text('Open Shop'),
              ),
            ),
          ],
          if (_isGuest) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Text(
                'Guest mode reminder: quest completion and rewards are only saved for logged-in accounts.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          _buildStatsCard(progressCurrent.toDouble(), progressMax.toDouble()),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Next daily reset in: ${_formatDuration(_timeUntilReset)}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Completed today: $_completedCount/${_quests.length}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ..._quests.map(_buildQuestTile),
        ],
      ),
    );
  }

  Widget _buildStatsCard(double progressCurrent, double progressMax) {
    final progress = progressMax == 0 ? 0.0 : (progressCurrent / progressMax);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _statChip('Level $_level'),
              const SizedBox(width: 8),
              _statChip('Coins $_coins'),
              const SizedBox(width: 8),
              _statChip('EXP $_exp'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Level progress',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 10,
            borderRadius: BorderRadius.circular(999),
            backgroundColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            color: const Color(0xFF395886),
          ),
          const SizedBox(height: 8),
          Text(
            '${progressCurrent.toInt()} / ${progressMax.toInt()} EXP toward next level',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildQuestTile(Quest quest) {
    final questSubtitle = quest.matchesAnyLesson
        ? 'Finish any lesson quiz'
        : 'Finish "${quest.lessonTitle}" quiz';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(
          quest.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: quest.isCompleted
              ? Colors.green
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        title: Text(
          quest.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          '$questSubtitle\nReward: +${quest.expReward} EXP, +${quest.coinReward} coins',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
