import '../../models/lesson.dart';
import '../../models/quiz_problem.dart';

final mechanicsLesson = Lesson(
  title: "Mechanics",
  description: "Understand motion, force, and Newton's laws.",
  sections: [
    LessonSection(
      content: """
      Mechanics studies motion and forces on objects.
      Newton's laws:
      1. An object remains at rest or in uniform motion unless acted upon.
      2. F = ma, force equals mass times acceleration.
      3. For every action, there is an equal and opposite reaction.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Compute the force for mass = 2kg, acceleration = 3 m/s²",
      type: QuestionType.typing,
      answer: "6",
      hint: "Use Newton's second law: F = m * a.",
    ),
    QuizProblem(
      question: "True or False: For every action, there is no reaction.",
      type: QuestionType.trueFalse,
      answer: "False",
      hint: "Newton's third law says action and reaction come in pairs.",
    ),
  ],
);

final energyLesson = Lesson(
  title: "Energy & Work",
  description: "Learn about work, kinetic energy, and potential energy.",
  sections: [
    LessonSection(
      content: """
      Work = Force × displacement × cos(θ)
      Kinetic energy KE = ½ mv²
      Potential energy PE = mgh
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "A 5kg object moves at 4 m/s. Find its kinetic energy.",
      type: QuestionType.typing,
      answer: "40",
      hint: "Apply KE = 1/2 * m * v^2.",
    ),
    QuizProblem(
      question: "True or False: Work and energy are measured in Joules.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "The SI unit for both is J.",
    ),
  ],
);

final physicsLessons = [mechanicsLesson, energyLesson];
