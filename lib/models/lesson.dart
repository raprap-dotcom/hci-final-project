import '../models/quiz_problem.dart';

class Lesson {
  final String title;
  final String description;
  final String? imagePath;
  final List<LessonSection> sections;
  final List<QuizProblem> quizProblems;

  Lesson({
    required this.title,
    required this.description,
    this.imagePath,
    required this.sections,
    required this.quizProblems,
  });
}

enum ContentImageOrient { left, right }

class LessonSection {
  final String content;
  final String? message;
  final String? imagePath;
  final ContentImageOrient? contentImageOrient;
  final String? additionalContent;

  LessonSection({
    required this.content,
    this.message,
    this.imagePath,
    this.contentImageOrient,
    this.additionalContent,
  });
}
