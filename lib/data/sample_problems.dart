import 'package:hci_final_project/models/quiz_problem.dart';

final List<QuizProblem> sampleProblems = [
  QuizProblem(
    question: "Solve for x: x + 2 = 5",
    type: QuestionType.dragAndDrop,
    options: ["x + 2 = 5", "3x - 4 = 8", "2x + 1 = 7"],
    answer: "x + 2 = 5",
    hint: "Isolate x by subtracting 2 from both sides.",
  ),
  QuizProblem(
    question: "Is 2 + 2 = 4?",
    type: QuestionType.trueFalse,
    options: ["True", "False"],
    answer: "True",
    hint: "Add the two integers directly.",
  ),
  QuizProblem(
    question: "What is 5 × 3?",
    type: QuestionType.typing,
    answer: "15",
    hint: "Think of 5 groups of 3.",
  ),
  QuizProblem(
    question: "Select the correct formula for area of a rectangle",
    type: QuestionType.dragAndDrop,
    options: ["A = l × w", "A = 2 × (l + w)", "A = l²"],
    answer: "A = l × w",
    hint: "Area uses length times width, not perimeter.",
  ),
];

final List<QuizProblem> linearAlgebra = [
  QuizProblem(
    question: "Solve for x: x + 2 = 5",
    type: QuestionType.dragAndDrop,
    options: ["x = 3", "x = 5", "x = 7"],
    answer: "x = 3",
    hint: "Move +2 to the other side by subtraction.",
  ),
  QuizProblem(
    question: "Is 2 + 2 = 4?",
    type: QuestionType.trueFalse,
    options: ["True", "False"],
    answer: "True",
    hint: "This is basic addition.",
  ),
  QuizProblem(
    question: "What is 5 × 3?",
    type: QuestionType.typing,
    answer: "15",
    hint: "Repeated addition: 5 + 5 + 5.",
  ),
  QuizProblem(
    question: "Select the correct formula for area of a rectangle",
    type: QuestionType.dragAndDrop,
    options: ["A = l × w", "A = 2 × (l + w)", "A = l²"],
    answer: "A = l × w",
    hint: "Rectangle area depends on two side lengths multiplied.",
  ),
];
