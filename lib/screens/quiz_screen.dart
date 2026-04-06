import 'package:flutter/material.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import '../models/quiz_problem.dart';
import '../progress_manager.dart';
import '../quest_manager.dart';
import '../widgets/drag_drop.dart';
import '../widgets/multiple_choice.dart';
import '../widgets/true_or_false.dart';
import '../widgets/typing.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizProblem> problems;
  final Color? themeColor;
  final String lessonTitle;

  const QuizScreen({
    super.key,
    required this.problems,
    required this.lessonTitle,
    this.themeColor,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  final Map<int, String> answers = {}; // Store all user answers

  void _previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _nextQuestion() {
    if (currentIndex < widget.problems.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Last question → Finish
      _showResults();
    }
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          problems: widget.problems,
          answers: answers,
          lessonTitle: widget.lessonTitle,
          themeColor: widget.themeColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problems[currentIndex];
    final userAnswer = answers[currentIndex];
    final themeColor = widget.themeColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final buttonBackground = isDark ? primary : (themeColor ?? primary);
    final buttonForeground =
        isDark ? Colors.white : Theme.of(context).colorScheme.onPrimary;

    Widget questionWidget;

    switch (problem.type) {
      case QuestionType.multipleChoice:
        questionWidget = MultipleChoiceQuestion(
          problem: problem,
          onAnswerSelected: (answer) =>
              setState(() => answers[currentIndex] = answer),
          selectedAnswer: userAnswer,
        );
        break;
      case QuestionType.trueFalse:
        questionWidget = TrueFalseQuestion(
          problem: problem,
          onAnswerSelected: (answer) =>
              setState(() => answers[currentIndex] = answer),
          selectedAnswer: userAnswer,
        );
        break;
      case QuestionType.typing:
        questionWidget = TypingQuestion(
          problem: problem,
          onAnswerSubmitted: (answer) =>
              setState(() => answers[currentIndex] = answer),
          initialText: userAnswer,
        );
        break;
      case QuestionType.dragAndDrop:
        questionWidget = DragDropQuestion(
          problem: problem,
          onAnswerDropped: (answer) =>
              setState(() => answers[currentIndex] = answer),
          initialAnswer: userAnswer,
        );
        break;
    }

    final isLastQuestion = currentIndex == widget.problems.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz (${currentIndex + 1}/${widget.problems.length})"),
        actions: const [ThemeToggleButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: questionWidget,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _previousQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackground,
                    foregroundColor: buttonForeground,
                  ),
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackground,
                    foregroundColor: buttonForeground,
                  ),
                  child: Text(isLastQuestion ? "Finish" : "Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple Results Screen
class QuizResultsScreen extends StatefulWidget {
  final List<QuizProblem> problems;
  final Map<int, String> answers;
  final String lessonTitle;
  final Color? themeColor;

  const QuizResultsScreen({
    super.key,
    required this.problems,
    required this.answers,
    required this.lessonTitle,
    this.themeColor,
  });

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  QuestCompletionResult? _rewardResult;

  @override
  void initState() {
    super.initState();
    _completeRelatedQuests();
  }

  Future<void> _completeRelatedQuests() async {
    final totalQuestions = widget.problems.length;
    final correctAnswers = widget.answers.entries.where((entry) {
      final index = entry.key;
      final answer = entry.value;
      if (index < 0 || index >= widget.problems.length) {
        return false;
      }
      return answer == widget.problems[index].answer;
    }).length;

    await ProgressManager.recordQuizCompletion(
      lessonTitle: widget.lessonTitle,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
    );

    final result = await QuestManager.completeQuestsForLesson(
      lessonTitle: widget.lessonTitle,
    );
    if (!mounted) return;

    setState(() {
      _rewardResult = result;
    });

    if (result.hasRewards) {
      final questCount = result.completedQuests.length;
      final questLabel = questCount == 1 ? 'quest' : 'quests';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Completed $questCount $questLabel. '
            '+${result.totalExpReward} EXP, +${result.totalCoinReward} coins.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final buttonBackground =
        isDark ? primary : (widget.themeColor ?? primary);
    final buttonForeground =
        isDark ? Colors.white : Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
        actions: const [ThemeToggleButton()],
      ),
      body: Column(
        children: [
          if (_rewardResult?.hasRewards == true)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Daily quest rewards collected: '
                '+${_rewardResult!.totalExpReward} EXP, '
                '+${_rewardResult!.totalCoinReward} coins',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

          // 🔹 LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.problems.length,
              itemBuilder: (context, index) {
                final problem = widget.problems[index];
                final userAnswer = widget.answers[index] ?? "No answer";
                final correct = userAnswer == problem.answer;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q${index + 1}: ${problem.question}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Your answer: $userAnswer",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.8),
                          ),
                        ),
                        Text(
                          "Correct answer: ${problem.answer}",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.8),
                          ),
                        ),
                        Text(
                          "Result: ${correct ? '✅ Correct' : '❌ Incorrect'}",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 BUTTON (ALWAYS AT BOTTOM)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Results → LessonDetail
                  Navigator.pop(context); // LessonDetail → LessonsScreen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBackground,
                  foregroundColor: buttonForeground,
                ),
                child: const Text("Back to Lessons"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
