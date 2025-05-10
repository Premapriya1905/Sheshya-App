import 'package:flutter/material.dart';
import 'package:learning/models/course_content.dart';
import 'package:learning/models/lesson_type.dart';
import 'package:learning/widgets/animated_background.dart';
import 'package:learning/widgets/audio_question_widget.dart';
import 'package:learning/widgets/fill_question_widget.dart';
import 'package:learning/widgets/image_match_widget.dart';
import 'package:learning/widgets/result_screen.dart';
import 'package:learning/widgets/sentence_question_widget.dart';

class LessonScreen extends StatefulWidget {
  final LessonType lessonType;
  final CourseContent content;
  final String gradeLabel;

  const LessonScreen({
    super.key,
    required this.lessonType,
    required this.content,
    required this.gradeLabel,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _showResult = false;
  List<dynamic> _questions = [];

  @override
  void initState() {
    super.initState();
    _initQuestions();
  }

  void _initQuestions() {
    switch (widget.lessonType) {
      case LessonType.fill:
        _questions = widget.content.fill ?? [];
        break;
      case LessonType.imageMatch:
        _questions = widget.content.imageMatch ?? [];
        break;
      case LessonType.audio:
        _questions = widget.content.audio ?? [];
        break;
      case LessonType.sentence:
        _questions = widget.content.sentence ?? [];
        break;
    }

    // Limit to 5 questions for each type
    if (_questions.length > 5) {
      _questions = _questions.sublist(0, 5);
    }
    
    // Reset state
    _currentQuestionIndex = 0;
    _score = 0;
    _showResult = false;
  }

  void _handleCorrectAnswer() {
    setState(() {
      _score++;
      _goToNextQuestion();
    });
  }

  void _handleWrongAnswer() {
    setState(() {
      _goToNextQuestion();
    });
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _showResult = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _showResult = false;
    });
  }

  String _getLessonTypeTitle() {
    switch (widget.lessonType) {
      case LessonType.fill:
        return 'Fill in the Blanks';
      case LessonType.imageMatch:
        return 'Match Images';
      case LessonType.audio:
        return 'Audio Quiz';
      case LessonType.sentence:
        return 'Form Sentences';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: AnimatedBackground(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No questions available for this lesson type.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_showResult) {
      return ResultScreen(
        score: _score,
        totalQuestions: _questions.length,
        onRestart: _restartQuiz,
        onBackToLessons: () => Navigator.pop(context),
      );
    }

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.gradeLabel} - ${_getLessonTypeTitle()}',
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildQuestionWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget() {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return const Center(child: Text('No questions available'));
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    // Create a unique key for each question to force widget recreation
    final questionKey = ValueKey('${widget.lessonType}_$_currentQuestionIndex');

    switch (widget.lessonType) {
      case LessonType.fill:
        return FillQuestionWidget(
          key: questionKey,
          question: currentQuestion,
          onCorrect: _handleCorrectAnswer,
          onWrong: _handleWrongAnswer,
        );
      case LessonType.imageMatch:
        return ImageMatchWidget(
          key: questionKey,
          question: currentQuestion,
          onCorrect: _handleCorrectAnswer,
          onWrong: _handleWrongAnswer,
        );
      case LessonType.audio:
        return AudioQuestionWidget(
          key: questionKey,
          question: currentQuestion,
          onCorrect: _handleCorrectAnswer,
          onWrong: _handleWrongAnswer,
        );
      case LessonType.sentence:
        return SentenceQuestionWidget(
          key: questionKey,
          question: currentQuestion,
          onCorrect: _handleCorrectAnswer,
          onWrong: _handleWrongAnswer,
        );
    }
  }
}