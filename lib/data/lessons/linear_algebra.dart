import '../../models/lesson.dart';
import '../../models/quiz_problem.dart';

final vectorLesson = Lesson(
  title: "Vectors",
  description: "Learn about vectors, addition, and scalar multiplication.",
  sections: [
    LessonSection(
      imagePath: "assets/vector.png",
      content:
          "A vector is a quantity that has both magnitude (size) and direction.\n\nExamples include displacement, velocity, and force.",
      message: "Think of a vector as an arrow pointing somewhere.",
      contentImageOrient: ContentImageOrient.right,
      additionalContent:
          "Quick check: if direction changes, it is not the same vector even when magnitude is equal.",
    ),
    LessonSection(
      content:
          "Vectors are often written in component form like:\n\nv = (x, y)\n\nThis means the vector moves x units horizontally and y units vertically.",
    ),
    LessonSection(
      content:
          "Vector addition combines two vectors:\n\n(u + v) = (x1 + x2, y1 + y2)\n\nYou simply add corresponding components.",
      message: "Add x with x, and y with y — that's it!",
      additionalContent: "Example: (2, -1) + (3, 4) = (5, 3).",
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
  quizProblems: [
    QuizProblem(
      question: "Which of the following is a vector in R³?",
      type: QuestionType.multipleChoice,
      options: ["(1,2,3)", "(1,2)", "3x + 2", "5"],
      answer: "(1,2,3)",
    ),
    QuizProblem(
      question: "True or False: The zero vector is in every vector space.",
      type: QuestionType.trueFalse,
      answer: "True",
    ),
    QuizProblem(
      question: "Drag the correct components to match the vector v = (2, -3):",
      type: QuestionType.dragAndDrop,
      options: ["2", "-3", "3", "1"],
      answer: "2,-3",
    ),
    QuizProblem(
      question: "Write the vector resulting from 2*(1,3):",
      type: QuestionType.typing,
      answer: "(2,6)",
    ),
  ],
);

final matrixLesson = Lesson(
  title: "Matrices",
  description: "Introduction to matrices, operations, and determinants.",
  sections: [
    LessonSection(
      content:
          "A matrix is a rectangular array of numbers arranged in rows and columns.",
      additionalContent:
          "Matrix size is written as rows x columns, such as 2x3.",
    ),
    LessonSection(
      content:
          "Matrices are used to represent systems of equations and linear transformations.",
    ),
    LessonSection(
      content:
          "Matrix addition and scalar multiplication follow rules similar to vectors, applied element-wise.",
      message: "Add corresponding elements, multiply each by the scalar.",
    ),
    LessonSection(
      content:
          "The determinant of a 2x2 matrix A = [[a, b], [c, d]] is det(A) = ad - bc.",
      message: "Determinants help determine if a matrix is invertible.",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "What is the determinant of [[2,3],[1,4]]?",
      type: QuestionType.typing,
      answer: "5",
    ),
    QuizProblem(
      question:
          "True or False: The sum of two matrices of the same dimensions is a matrix of the same dimensions.",
      type: QuestionType.trueFalse,
      answer: "True",
    ),
    QuizProblem(
      question: "Which of these is a valid 2x2 matrix?",
      type: QuestionType.multipleChoice,
      options: [
        "[[1,2],[3,4]]",
        "[1,2,3]",
        "[[1,2,3],[4,5,6],[7,8,9]]",
        "[1,2],[3,4]",
      ],
      answer: "[[1,2],[3,4]]",
    ),
  ],
);

final linearSystemsLesson = Lesson(
  title: "Linear Systems",
  description:
      "Solve systems of linear equations using substitution, elimination, and matrices.",
  sections: [
    LessonSection(
      content: """
      A linear system is a set of equations where each equation is linear in the variables.

      Example: 
      x + y = 3
      2x - y = 1

      Solutions can be unique, infinite, or none.
      """,
      additionalContent:
          "Always check the number of equations versus variables before choosing a solving method.",
    ),
    LessonSection(
      content: """
      Methods to solve:
      - Substitution: solve one variable, substitute in others
      - Elimination: add/subtract equations to eliminate a variable
      - Matrix methods: use augmented matrices and row reduction (Gaussian elimination)
      """,
    ),
    LessonSection(
      content: """
      Representing systems in matrix form: Ax = b, where A is the coefficient matrix, x is the vector of variables, and b is the constants vector.

      If det(A) != 0, the system has a unique solution.
      """,
      additionalContent:
          "When det(A) = 0, test consistency to know if the system has no solution or infinitely many.",
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "True or False: A system with det(A) = 0 always has no solution.",
      type: QuestionType.trueFalse,
      answer: "False",
    ),
    QuizProblem(
      question:
          "Which method is used to systematically reduce matrices to row-echelon form?",
      type: QuestionType.multipleChoice,
      options: [
        "Substitution",
        "Gaussian elimination",
        "Cross multiplication",
        "Factorization",
      ],
      answer: "Gaussian elimination",
    ),
    QuizProblem(
      question: "Solve the system: x + y = 3, x - y = 1",
      type: QuestionType.typing,
      answer: "x=2,y=1",
    ),
  ],
);

final determinantsRankLesson = Lesson(
  title: "Determinants & Rank",
  description:
      "Learn how determinants and rank determine matrix properties and solutions of linear systems.",
  sections: [
    LessonSection(
      content: """
      The determinant of a square matrix is a scalar value that can indicate whether the matrix is invertible.

      2x2 matrix: det([[a,b],[c,d]]) = ad - bc
      3x3 matrix: use expansion by minors.
      """,
    ),
    LessonSection(
      content: """
      Rank of a matrix is the dimension of the row or column space. 
      - Rank helps determine if a system has a unique solution or infinitely many solutions.
      - A full-rank matrix is invertible if it is square.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "True or False: If a square matrix has rank less than its size, it is invertible.",
      type: QuestionType.trueFalse,
      answer: "False",
    ),
    QuizProblem(
      question: "Compute the determinant: [[1,2],[3,4]]",
      type: QuestionType.typing,
      answer: "-2",
    ),
  ],
);

final eigenLesson = Lesson(
  title: "Eigenvalues & Eigenvectors",
  description:
      "Learn how eigenvalues and eigenvectors describe matrix behavior and transformations.",
  sections: [
    LessonSection(
      content: """
      Eigenvectors are vectors that remain in the same direction under a transformation.
      Eigenvalues are scalars λ satisfying Av = λv.
      """,
      additionalContent:
          "In short, eigenvectors keep their direction while only being scaled.",
    ),
    LessonSection(
      content: """
      Characteristic equation: det(A - λI) = 0
      Solutions λ are eigenvalues; corresponding vectors v are eigenvectors.
      """,
    ),
    LessonSection(
      content: """
      Applications: stability analysis, principal component analysis (PCA), and understanding transformations geometrically.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "True or False: Eigenvectors can be scaled by any nonzero scalar.",
      type: QuestionType.trueFalse,
      answer: "True",
    ),
    QuizProblem(
      question: "Which equation defines eigenvalues λ?",
      type: QuestionType.multipleChoice,
      options: ["Av = λv", "A+v = λv", "det(A) = λ", "Av = v"],
      answer: "Av = λv",
    ),
  ],
);

final orthogonalityLesson = Lesson(
  title: "Orthogonality",
  description:
      "Understand dot product, orthogonal vectors, projection, and orthogonal bases.",
  sections: [
    LessonSection(
      content: """
      Two vectors u and v are orthogonal if their dot product is zero: u·v = 0.
      """,
    ),
    LessonSection(
      content: """
      Orthogonal projections: project vector u onto v using proj_v(u) = (u·v / v·v) v
      """,
    ),
    LessonSection(
      content: """
      An orthogonal basis consists of vectors that are mutually orthogonal.
      Gram-Schmidt process converts any basis into an orthogonal one.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "True or False: Dot product of orthogonal vectors is zero.",
      type: QuestionType.trueFalse,
      answer: "True",
    ),
    QuizProblem(
      question: "Compute the projection of u=(3,4) onto v=(1,0)",
      type: QuestionType.typing,
      answer: "(3,0)",
    ),
  ],
);

final diagonalizationLesson = Lesson(
  title: "Diagonalization",
  description:
      "Learn how to diagonalize a matrix and simplify powers of matrices.",
  sections: [
    LessonSection(
      content: """
      A matrix A is diagonalizable if there exists an invertible P such that P⁻¹AP = D, where D is diagonal.
      """,
    ),
    LessonSection(
      content: """
      Diagonalization simplifies matrix powers: A^k = P D^k P⁻¹
      """,
    ),
    LessonSection(
      content: """
      Only matrices with enough linearly independent eigenvectors are diagonalizable.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question: "True or False: Every square matrix is diagonalizable.",
      type: QuestionType.trueFalse,
      answer: "False",
    ),
  ],
);

final vectorSpacesLesson = Lesson(
  title: "Vector Spaces & Basis",
  description:
      "Learn about vector spaces, subspaces, linear independence, basis, and dimension.",
  sections: [
    LessonSection(
      content: """
      A vector space is a set of vectors closed under addition and scalar multiplication.
      A subspace is a subset that is itself a vector space.
      """,
    ),
    LessonSection(
      content: """
      Vectors are linearly independent if no vector is a combination of others.
      Basis is a set of linearly independent vectors spanning the space.
      Dimension is the number of vectors in a basis.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "True or False: A basis must consist of linearly independent vectors.",
      type: QuestionType.trueFalse,
      answer: "True",
    ),
  ],
);

final applicationsLesson = Lesson(
  title: "Applications",
  description:
      "Explore real-world applications of linear algebra in graphics, ML, and physics.",
  sections: [
    LessonSection(
      content: """
      Linear algebra is used in computer graphics for rotations, scaling, and 3D transformations.
      In machine learning, PCA reduces dimensionality using eigenvectors.
      Physics uses vectors and matrices to represent forces, motion, and systems.
      """,
    ),
  ],
  quizProblems: [
    QuizProblem(
      question:
          "True or False: PCA uses eigenvectors to reduce data dimensions.",
      type: QuestionType.trueFalse,
      answer: "True",
    ),
  ],
);

final linearAlgebraLessons = [
  vectorLesson,
  matrixLesson,
  linearSystemsLesson,
  determinantsRankLesson,
  eigenLesson,
  orthogonalityLesson,
  diagonalizationLesson,
  vectorSpacesLesson,
  applicationsLesson,
];
