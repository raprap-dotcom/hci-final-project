import 'package:hci_final_project/data/sample_problems.dart';
import '../models/lesson.dart';

final vectorLesson = Lesson(
  title: "Vectors",
  description: "Learn about vectors, addition, and scalar multiplication.",
  sections: [
    LessonSection(
      content:
          "A vector is a quantity that has both magnitude (size) and direction.\n\nExamples include displacement, velocity, and force.",
      message: "Think of a vector as an arrow pointing somewhere.",
      imagePath: "assets/vector.png",
    ),
    LessonSection(
      content:
          "Vectors are often written in component form like:\n\nv = (x, y)\n\nThis means the vector moves x units horizontally and y units vertically.",
    ),
    LessonSection(
      content:
          "Vector addition combines two vectors:\n\n(u + v) = (x1 + x2, y1 + y2)\n\nYou simply add corresponding components.",
      message: "Add x with x, and y with y — that's it!",
    ),
    LessonSection(
      content:
          "Scalar multiplication means multiplying a vector by a number:\n\nk·v = (k×x, k×y)\n\nThis changes the length of the vector.",
      message:
          "If k > 1, the vector gets longer. If 0 < k < 1, it gets shorter.",
    ),
    LessonSection(
      content:
          "Vectors are fundamental in physics, computer graphics, and machine learning.\n\nThey help describe motion, direction, and transformations.",
      message: "You’ll see vectors everywhere in tech and science!",
    ),
  ],
  quizProblems: sampleProblems,
);

final linearAlgebraLessons = [
  vectorLesson,
  Lesson(
    title: "Matrices",
    description: "Introduction to matrices, operations, and determinants.",
    sections: [
      LessonSection(
        content:
            "A matrix is a rectangular array of numbers arranged in rows and columns.",
      ),
      LessonSection(
        content:
            "Matrices are used to represent systems of equations and transformations.",
      ),
    ],
    quizProblems: sampleProblems,
  ),
];
