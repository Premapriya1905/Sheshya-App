import 'package:flutter/material.dart';
import 'package:learning/widgets/animated_background.dart';
import 'package:learning/widgets/bouncing_button.dart';
import 'package:confetti/confetti.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRestart;
  final VoidCallback onBackToLessons;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRestart,
    required this.onBackToLessons,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    if (widget.score / widget.totalQuestions >= 0.7) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _getResultMessage() {
    final percentage = widget.score / widget.totalQuestions;
    
    if (percentage == 1) {
      return 'Perfect! You\'re amazing! 🌟';
    } else if (percentage >= 0.8) {
      return 'Great job! You did excellent! 🎉';
    } else if (percentage >= 0.6) {
      return 'Good work! Keep practicing! 👍';
    } else if (percentage >= 0.4) {
      return 'Nice try! Let\'s practice more! 💪';
    } else {
      return 'Keep learning! You can do better next time! 📚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.score / widget.totalQuestions;
    final Color resultColor = percentage >= 0.7
        ? Colors.green
        : percentage >= 0.4
            ? Colors.orange
            : Colors.red;
    
    return Scaffold(
      body: AnimatedBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Quiz Results',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: resultColor,
                            width: 8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: resultColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.score}',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: resultColor,
                                ),
                              ),
                              Text(
                                'out of ${widget.totalQuestions}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: resultColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: resultColor.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          _getResultMessage(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: resultColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BouncingButton(
                            onTap: widget.onBackToLessons,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blue, width: 2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.arrow_back,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Back to Lessons',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          BouncingButton(
                            onTap: widget.onRestart,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.green, width: 2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.refresh,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Try Again',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.yellow,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}