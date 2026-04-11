enum QuestionType { multipleChoice, trueFalse, dragAndDrop, typing }

class QuizProblem {
  final String question; // The question text
  final QuestionType type; // Type of question
  final List<String>? options; // For multiple choice or drag options
  final String answer; // Correct answer (can be a formula string for drag/drop)
  final String? hint; // Optional hint shown to the learner

  QuizProblem({
    required this.question,
    required this.type,
    this.options,
    required this.answer,
    this.hint,
  });
}
