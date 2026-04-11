import '../../models/lesson.dart';
import '../../models/quiz_problem.dart';

final integrationBasicsLesson = Lesson(
  title: "Integration Basics",
  description:
      "Learn the concept of integrals as the reverse of differentiation.",
  sections: [
    LessonSection(
      content: """
      Integration is the reverse process of differentiation. 
      The indefinite integral of a function f(x) is F(x) + C, where F'(x) = f(x) and C is the constant of integration.
      """,
    ),
    LessonSection(
      content: """
      Notation: ∫ f(x) dx represents the integral of f(x) with respect to x.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Find the indefinite integral of f(x) = 2x.",
      type: QuestionType.typing,
      answer: "x^2 + C",
      hint: "Use the power rule for integrals and remember + C.",
    ),
    QuizProblem(
      question: "True or False: Integration always reverses differentiation.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "Indefinite integration is an antiderivative operation.",
    ),
  ],
);

final definiteIntegralsLesson = Lesson(
  title: "Definite Integrals",
  description: "Compute the area under a curve using definite integrals.",
  sections: [
    LessonSection(
      content: """
      A definite integral ∫[a,b] f(x) dx calculates the net area under f(x) from x = a to x = b.
      It has a numeric value, unlike indefinite integrals.
      """,
    ),
    LessonSection(
      content: """
      Fundamental Theorem of Calculus:
      If F'(x) = f(x), then ∫[a,b] f(x) dx = F(b) - F(a)
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "Compute ∫[0,2] 3x^2 dx",
      type: QuestionType.typing,
      answer: "8",
      hint: "Find an antiderivative first, then evaluate upper minus lower.",
    ),
    QuizProblem(
      question: "True or False: Definite integrals give a numeric value.",
      type: QuestionType.trueFalse,
      answer: "True",
      hint: "Definite integrals evaluate across bounds.",
    ),
  ],
);

final integralCalculusLessons = [
  integrationBasicsLesson,
  definiteIntegralsLesson,
];
