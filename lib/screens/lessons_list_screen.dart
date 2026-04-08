import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/progress_manager.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import '../models/lesson.dart';
import 'quiz_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final Color? themeColor;
  final VoidCallback? onProgressUpdated;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    this.themeColor,
    this.onProgressUpdated,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: const [ThemeToggleButton()],
      ),
      body: LessonDetailBody(
        lesson: lesson,
        themeColor: widget.themeColor,
        onProgressUpdated: widget.onProgressUpdated,
      ),
    );
  }
}

class LessonDetailBody extends StatefulWidget {
  final Lesson lesson;
  final Color? themeColor;
  final bool showBackButton;
  final VoidCallback? onProgressUpdated;

  const LessonDetailBody({
    super.key,
    required this.lesson,
    this.themeColor,
    this.showBackButton = true,
    this.onProgressUpdated,
  });

  @override
  State<LessonDetailBody> createState() => _LessonDetailBodyState();
}

class _LessonDetailBodyState extends State<LessonDetailBody> {
  int _visibleSectionCount = 1;
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _sectionKeys = List.generate(
      widget.lesson.sections.length,
      (_) => GlobalKey(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markLessonReadIfComplete();
    });
  }

  @override
  void didUpdateWidget(covariant LessonDetailBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.title != widget.lesson.title) {
      _visibleSectionCount = 1;
      _sectionKeys = List.generate(
        widget.lesson.sections.length,
        (_) => GlobalKey(),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _markLessonReadIfComplete();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _hasMoreSections =>
      _visibleSectionCount < widget.lesson.sections.length;

  Future<void> _markLessonReadIfComplete() async {
    if (_visibleSectionCount >= widget.lesson.sections.length) {
      await ProgressManager.markLessonRead(widget.lesson.title);
      widget.onProgressUpdated?.call();
    }
  }

  void _continueSection() {
    if (_hasMoreSections) {
      final nextIndex = _visibleSectionCount;
      setState(() {
        _visibleSectionCount++;
      });
      _markLessonReadIfComplete();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final targetContext = _sectionKeys[nextIndex].currentContext;
        if (targetContext != null) {
          Scrollable.ensureVisible(
            targetContext,
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeOutCubic,
            alignment: 0.08,
          );
          return;
        }

        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.themeColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final buttonBackground = isDark ? primary : (themeColor ?? primary);
    final buttonForeground = isDark
        ? Colors.white
        : Theme.of(context).colorScheme.onPrimary;
    final outlineForeground = isDark
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;
    final outlineSideColor = isDark
        ? Colors.white
        : (themeColor ?? outlineForeground);
    final width = MediaQuery.of(context).size.width;
    final contentMaxWidth = width >= 1400
        ? 760.0
        : width >= 1100
        ? 680.0
        : 900.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (
                        var index = 0;
                        index < _visibleSectionCount;
                        index++
                      ) ...[
                        _LessonSectionCard(
                          key: _sectionKeys[index],
                          section: widget.lesson.sections[index],
                        ),
                        const SizedBox(height: 14),
                      ],
                      if (_hasMoreSections)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _continueSection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonBackground,
                              foregroundColor: buttonForeground,
                            ),
                            child: Text(
                              'Continue ($_visibleSectionCount/${widget.lesson.sections.length})',
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            if (widget.lesson.quizProblems.isNotEmpty)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizScreen(
                                          problems: widget.lesson.quizProblems,
                                          themeColor: themeColor,
                                          lessonTitle: widget.lesson.title,
                                          backToLessonsPopCount:
                                              widget.showBackButton ? 2 : 1,
                                        ),
                                      ),
                                    ).then(
                                      (_) => widget.onProgressUpdated?.call(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonBackground,
                                    foregroundColor: buttonForeground,
                                  ),
                                  child: const Text('Take Quiz'),
                                ),
                              ),
                            if (widget.showBackButton) ...[
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: outlineForeground,
                                    side: BorderSide(color: outlineSideColor),
                                  ),
                                  child: const Text('Back to Lessons'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonSectionCard extends StatelessWidget {
  final LessonSection section;

  const _LessonSectionCard({super.key, required this.section});

  Widget _buildContentText(BuildContext context, String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 900;
    final imageMaxWidth = width >= 1400
        ? 420.0
        : width >= 1100
        ? 480.0
        : 560.0;

    final imageWidget = section.imagePath == null
        ? null
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: imageMaxWidth),
            child: Image.asset(
              section.imagePath!,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          );

    final contentWidget = _buildContentText(context, section.content);

    final useSideBySide =
        !isCompact && imageWidget != null && section.contentImageOrient != null;

    Widget buildMainContentBlock() {
      if (useSideBySide) {
        final isContentLeft =
            section.contentImageOrient == ContentImageOrient.left;
        final left = isContentLeft
            ? Expanded(child: contentWidget)
            : Expanded(child: imageWidget);
        final right = isContentLeft
            ? Expanded(child: imageWidget)
            : Expanded(child: contentWidget);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [left, const SizedBox(width: 16), right],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageWidget != null) ...[
            Center(child: imageWidget),
            const SizedBox(height: 12),
          ],
          contentWidget,
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.message != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                section.message!,
                style: GoogleFonts.inter(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          buildMainContentBlock(),
          if (section.additionalContent != null) ...[
            const SizedBox(height: 12),
            _buildContentText(context, section.additionalContent!),
          ],
        ],
      ),
    );
  }
}

class LessonsScreen extends StatefulWidget {
  final List<Lesson> lessons;
  final Color? themeColor;

  const LessonsScreen({super.key, required this.lessons, this.themeColor});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  int _selectedLessonIndex = 0;
  Map<String, LessonProgressStatus> _lessonStatuses = const {};

  @override
  void initState() {
    super.initState();
    _refreshLessonStatuses();
  }

  Future<void> _refreshLessonStatuses() async {
    final titles = widget.lessons.map((lesson) => lesson.title).toList();
    final statuses = await ProgressManager.getLessonProgressStatuses(titles);
    if (!mounted) {
      return;
    }
    setState(() {
      _lessonStatuses = statuses;
    });
  }

  Widget _buildStatusBadge(LessonProgressStatus? status) {
    final hasQuiz = status?.quizCompleted == true;
    final hasReadOnly = status?.lessonRead == true && !hasQuiz;

    if (!hasQuiz && !hasReadOnly) {
      return const SizedBox.shrink();
    }

    final label = hasQuiz ? 'Quiz done' : 'Read only';
    final bgColor = hasQuiz
        ? const Color(0xFF1F9D63).withValues(alpha: 0.14)
        : const Color(0xFF4B6A9B).withValues(alpha: 0.14);
    final fgColor = hasQuiz ? const Color(0xFF15784B) : const Color(0xFF2F4F79);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1000;
    final selectedLesson = widget.lessons[_selectedLessonIndex];

    if (isWide) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lessons'),
          actions: const [ThemeToggleButton()],
        ),
        body: Row(
          children: [
            SizedBox(
              width: 360,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.lessons.length,
                itemBuilder: (context, index) {
                  final lesson = widget.lessons[index];
                  final isSelected = index == _selectedLessonIndex;
                  final status = _lessonStatuses[lesson.title];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.16)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest
                              : widget.themeColor),
                    child: ListTile(
                      selected: isSelected,
                      leading: lesson.imagePath != null
                          ? Image.asset(
                              lesson.imagePath!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.menu_book_rounded, size: 28),
                      title: Text(
                        lesson.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.72),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildStatusBadge(status),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedLessonIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
            Expanded(
              child: LessonDetailBody(
                key: ValueKey(selectedLesson.title),
                lesson: selectedLesson,
                themeColor: widget.themeColor,
                showBackButton: false,
                onProgressUpdated: _refreshLessonStatuses,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.lessons.length,
        itemBuilder: (context, index) {
          final lesson = widget.lessons[index];
          final status = _lessonStatuses[lesson.title];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : widget.themeColor,
            child: ListTile(
              leading: lesson.imagePath != null
                  ? Image.asset(
                      lesson.imagePath!,
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.menu_book_rounded, size: 30),
              title: Text(
                lesson.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                lesson.description,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusBadge(status),
                  if (status?.quizCompleted != true &&
                      status?.lessonRead != true)
                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                ],
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailScreen(
                      lesson: lesson,
                      themeColor: widget.themeColor,
                      onProgressUpdated: _refreshLessonStatuses,
                    ),
                  ),
                );
                _refreshLessonStatuses();
              },
            ),
          );
        },
      ),
    );
  }
}
