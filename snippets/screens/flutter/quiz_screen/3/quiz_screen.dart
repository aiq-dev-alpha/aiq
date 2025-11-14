import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _timerController;
  late Animation<double> _progressAnimation;

  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeRemaining = 30;
  bool _isQuizActive = false;
  bool _isQuizCompleted = false;
  bool _showResults = false;
  Map<int, String> _selectedAnswers = {};

  late List<QuizQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _timerController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_progressController);
    _initializeQuestions();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  void _initializeQuestions() {
    _questions = [
      QuizQuestion(
        question: "What is the capital of France?",
        options: ["London", "Berlin", "Paris", "Madrid"],
        correctAnswer: 2,
        points: 10,
        category: "Geography",
      ),
      QuizQuestion(
        question: "Which planet is known as the Red Planet?",
        options: ["Venus", "Mars", "Jupiter", "Saturn"],
        correctAnswer: 1,
        points: 10,
        category: "Science",
      ),
      QuizQuestion(
        question: "Who wrote 'Romeo and Juliet'?",
        options: ["Charles Dickens", "William Shakespeare", "Mark Twain", "Jane Austen"],
        correctAnswer: 1,
        points: 15,
        category: "Literature",
      ),
      QuizQuestion(
        question: "What is 15 + 27?",
        options: ["40", "41", "42", "43"],
        correctAnswer: 2,
        points: 5,
        category: "Mathematics",
      ),
      QuizQuestion(
        question: "Which year did World War II end?",
        options: ["1944", "1945", "1946", "1947"],
        correctAnswer: 1,
        points: 10,
        category: "History",
      ),
      QuizQuestion(
        question: "What is the largest mammal in the world?",
        options: ["Elephant", "Blue Whale", "Giraffe", "Hippopotamus"],
        correctAnswer: 1,
        points: 10,
        category: "Biology",
      ),
      QuizQuestion(
        question: "Which programming language is known for 'Write Once, Run Anywhere'?",
        options: ["Python", "C++", "Java", "JavaScript"],
        correctAnswer: 2,
        points: 15,
        category: "Technology",
      ),
      QuizQuestion(
        question: "What is the chemical symbol for gold?",
        options: ["Go", "Gd", "Au", "Ag"],
        correctAnswer: 2,
        points: 10,
        category: "Chemistry",
      ),
    ];
  }

  void _startQuiz() {
    setState(() {
      _isQuizActive = true;
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswers.clear();
      _timeRemaining = 30;
    });
    _startTimer();
    _progressController.animateTo((_currentQuestionIndex + 1) / _questions.length);
  }

  void _startTimer() {
    _timerController.reset();
    _timerController.forward().then((_) {
      if (_isQuizActive && !_isQuizCompleted) {
        _nextQuestion();
      }
    });
  }

  void _selectAnswer(int answerIndex) {
    if (!_isQuizActive || _isQuizCompleted) return;

    setState(() {
      _selectedAnswers[_currentQuestionIndex] = _questions[_currentQuestionIndex].options[answerIndex];
    });

    // Check if answer is correct
    if (answerIndex == _questions[_currentQuestionIndex].correctAnswer) {
      setState(() {
        _score += _questions[_currentQuestionIndex].points;
      });
    }

    // Move to next question after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    _timerController.stop();

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timeRemaining = 30;
      });
      _startTimer();
      _progressController.animateTo((_currentQuestionIndex + 1) / _questions.length);
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    setState(() {
      _isQuizActive = false;
      _isQuizCompleted = true;
    });
    _timerController.stop();
    _showQuizResults();
  }

  void _showQuizResults() {
    setState(() {
      _showResults = true;
    });
  }

  void _restartQuiz() {
    setState(() {
      _isQuizActive = false;
      _isQuizCompleted = false;
      _showResults = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswers.clear();
    });
    _progressController.reset();
  }

  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'General Knowledge Quiz',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.quiz_outlined),
                        const SizedBox(width: 8),
                        Text('${_questions.length} Questions'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(width: 8),
                        const Text('30 seconds per question'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star),
                        const SizedBox(width: 8),
                        Text('Total Points: ${_questions.fold(0, (sum, q) => sum + q.points)}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Quiz',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Test your knowledge across multiple categories!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final question = _questions[_currentQuestionIndex];
    final selectedAnswer = _selectedAnswers[_currentQuestionIndex];

    return Column(
      children: [
        // Header with progress and timer
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: question.getCategoryColor(),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      question.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.grey.shade300,
                  );
                },
              ),
            ],
          ),
        ),

        // Timer
        Container(
          margin: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _timerController,
                builder: (context, child) {
                  final remaining = (30 * (1 - _timerController.value)).round();
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: remaining <= 10 ? Colors.red : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${remaining}s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Question content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                '${question.points}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Points',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          question.question,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Answer options
                ...question.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = selectedAnswer == option;
                  final isCorrect = index == question.correctAnswer;
                  final showResult = selectedAnswer != null;

                  Color? backgroundColor;
                  Color? borderColor;
                  if (showResult) {
                    if (isSelected && isCorrect) {
                      backgroundColor = Colors.green.shade100;
                      borderColor = Colors.green;
                    } else if (isSelected && !isCorrect) {
                      backgroundColor = Colors.red.shade100;
                      borderColor = Colors.red;
                    } else if (isCorrect) {
                      backgroundColor = Colors.green.shade100;
                      borderColor = Colors.green;
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: selectedAnswer == null ? () => _selectAnswer(index) : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                            color: borderColor ?? Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: backgroundColor != null
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.grey.shade300,
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: TextStyle(
                                  color: backgroundColor != null ? Colors.white : Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (showResult && isCorrect)
                              const Icon(Icons.check, color: Colors.green),
                            if (showResult && isSelected && !isCorrect)
                              const Icon(Icons.close, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),

        // Score display
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Score: $_score',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    final totalPoints = _questions.fold(0, (sum, q) => sum + q.points);
    final percentage = (_score / totalPoints * 100).round();

    String grade;
    Color gradeColor;
    if (percentage >= 90) {
      grade = 'A+';
      gradeColor = Colors.green;
    } else if (percentage >= 80) {
      grade = 'A';
      gradeColor = Colors.green;
    } else if (percentage >= 70) {
      grade = 'B';
      gradeColor = Colors.blue;
    } else if (percentage >= 60) {
      grade = 'C';
      gradeColor = Colors.orange;
    } else {
      grade = 'F';
      gradeColor = Colors.red;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.emoji_events,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Quiz Completed!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: gradeColor,
                    child: Text(
                      grade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$percentage%',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$_score',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Text('Score'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '$totalPoints',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Text('Total'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${_questions.length}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const Text('Questions'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question Review',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    final selectedAnswer = _selectedAnswers[index] ?? 'No answer';
                    final correctAnswer = question.options[question.correctAnswer];
                    final isCorrect = selectedAnswer == correctAnswer;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Q${index + 1}: ${question.question}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                '+${question.points}',
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Your answer: $selectedAnswer'),
                          if (!isCorrect)
                            Text(
                              'Correct answer: $correctAnswer',
                              style: const TextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _restartQuiz,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Finish'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        elevation: 0,
        actions: [
          if (_isQuizActive)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Quit Quiz?'),
                    content: const Text('Your progress will be lost.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _restartQuiz();
                        },
                        child: const Text('Quit'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: !_isQuizActive && !_showResults
            ? _buildStartScreen()
            : _showResults
                ? _buildResultsScreen()
                : _buildQuestionScreen(),
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final int points;
  final String category;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.points,
    required this.category,
  });

  Color getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'geography':
        return Colors.blue;
      case 'science':
        return Colors.green;
      case 'literature':
        return Colors.purple;
      case 'mathematics':
        return Colors.orange;
      case 'history':
        return Colors.brown;
      case 'biology':
        return Colors.teal;
      case 'technology':
        return Colors.indigo;
      case 'chemistry':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}