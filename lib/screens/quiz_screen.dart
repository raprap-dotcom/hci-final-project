import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';
import '../widgets/drag_drop.dart';
import '../widgets/multiple_choice.dart';
import '../widgets/true_or_false.dart';
import '../widgets/typing.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizProblem> problems;

  const QuizScreen({super.key, required this.problems});

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
        builder: (context) =>
            QuizResultsScreen(problems: widget.problems, answers: answers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problems[currentIndex];
    final userAnswer = answers[currentIndex];

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(child: questionWidget),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _previousQuestion : null,
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: _nextQuestion,
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
class QuizResultsScreen extends StatelessWidget {
  final List<QuizProblem> problems;
  final Map<int, String> answers;

  const QuizResultsScreen({
    super.key,
    required this.problems,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: Column(
        children: [
          // 🔹 LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: problems.length,
              itemBuilder: (context, index) {
                final problem = problems[index];
                final userAnswer = answers[index] ?? "No answer";
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("Your answer: $userAnswer"),
                        Text("Correct answer: ${problem.answer}"),
                        Text(
                          "Result: ${correct ? '✅ Correct' : '❌ Incorrect'}",
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
                child: const Text("Back to Lessons"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
