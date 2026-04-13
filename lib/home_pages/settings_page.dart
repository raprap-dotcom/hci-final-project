import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback onGoToSubjects;
  final ValueChanged<double> onTextScaleChanged;

  const SettingsPage({
    super.key,
    required this.onGoToSubjects,
    required this.onTextScaleChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _textSize = 'Medium';

  double _getScale(String size) {
    switch (size) {
      case 'Small':
        return 0.85;
      case 'Large':
        return 1.25;
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _sectionLabel('Learning'),
          _card([
            _navRow(
              icon: Icons.menu_book_outlined,
              iconBg: const Color(0xFFDCFCE7),
              label: 'Subjects',
              sub: 'Manage enrolled subjects',
              onTap: widget.onGoToSubjects,
            ),
          ]),

          _sectionLabel('Appearance'),
          _card([
            _navRow(
              icon: Icons.text_fields,
              iconBg: const Color(0xFFDBEAFE),
              label: 'Text Size',
              sub: 'Adjust readability',
              trailing: _pill(_textSize),
              onTap: () => _showTextSizePicker(context),
            ),
          ]),

          _sectionLabel('Danger Zone'),
          _card([
            _navRow(
              icon: Icons.delete_outline,
              iconBg: const Color(0xFFFEE2E2),
              label: 'Reset Progress',
              sub: 'Wipe XP, level, and gold',
              labelColor: Colors.red,
              onTap: () => _confirmReset(context),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            letterSpacing: 1.2,
          ),
        ),
      );

  Widget _card(List<Widget> rows) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: rows),
      );

  Widget _navRow({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String sub,
    required VoidCallback onTap,
    Widget? trailing,
    Color? labelColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            _iconWrap(icon, iconBg),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: labelColor ??
                          Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing,
              const SizedBox(width: 6),
            ],
            Icon(
              Icons.chevron_right,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconWrap(IconData icon, Color bg) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
      );

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
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

  void _showTextSizePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Small', 'Medium', 'Large']
              .map(
                (size) => ListTile(
                  title: Text(
                    size,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: _textSize == size
                      ? Icon(Icons.check,
                          color:
                              Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    setState(() => _textSize = size);
                    widget.onTextScaleChanged(_getScale(size));
                    setModalState(() {});
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Reset Progress?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'This will wipe all your XP, gold, and level.',
          style: GoogleFonts.poppins(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}