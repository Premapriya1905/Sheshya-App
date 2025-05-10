import 'package:flutter/material.dart';
import 'package:learning/widgets/bouncing_button.dart';

class FillQuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  const FillQuestionWidget({
    super.key,
    required this.question,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  State<FillQuestionWidget> createState() => _FillQuestionWidgetState();
}

class _FillQuestionWidgetState extends State<FillQuestionWidget> {
  String? _selectedOption;
  bool _hasSubmitted = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    // Reset state when a new question is loaded
    _selectedOption = null;
    _hasSubmitted = false;
    _isCorrect = false;
  }

  @override
  void didUpdateWidget(FillQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset state when the question changes
    if (oldWidget.question != widget.question) {
      setState(() {
        _selectedOption = null;
        _hasSubmitted = false;
        _isCorrect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionText = widget.question['question'] as String;
    final options = List<String>.from(widget.question['options'] ?? []);
    final correctAnswer = widget.question['answer'] as String;

    // Split the question text to find where the blank is
    final parts = questionText.split('_____');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Fill in the blank:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.purple[800],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          height: 1.5,
                        ),
                    children: [
                      TextSpan(text: parts[0]),
                      WidgetSpan(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _hasSubmitted
                                    ? (_isCorrect ? Colors.green : Colors.red)
                                    : Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                          child: _selectedOption != null
                              ? Text(
                                  _selectedOption!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _hasSubmitted
                                        ? (_isCorrect ? Colors.green : Colors.red)
                                        : Colors.black,
                                  ),
                                )
                              : const SizedBox(width: 60, height: 24),
                        ),
                      ),
                      if (parts.length > 1) TextSpan(text: parts[1]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Choose the correct answer:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: options.map((option) {
              final isSelected = _selectedOption == option;
              final isCorrectOption = option == correctAnswer;
              
              Color backgroundColor = Colors.white;
              Color borderColor = Colors.grey;
              Color textColor = Colors.black87;
              
              if (_hasSubmitted) {
                if (isCorrectOption) {
                  backgroundColor = Colors.green.withOpacity(0.2);
                  borderColor = Colors.green;
                  textColor = Colors.green.shade800;
                } else if (isSelected && !isCorrectOption) {
                  backgroundColor = Colors.red.withOpacity(0.2);
                  borderColor = Colors.red;
                  textColor = Colors.red.shade800;
                }
              } else if (isSelected) {
                backgroundColor = Colors.blue.withOpacity(0.2);
                borderColor = Colors.blue;
                textColor = Colors.blue.shade800;
              }
              
              return BouncingButton(
                onTap: _hasSubmitted ? null : () {
                  setState(() {
                    _selectedOption = option;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: textColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          if (!_hasSubmitted)
            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : () {
                      final isCorrect = _selectedOption == correctAnswer;
                      setState(() {
                        _hasSubmitted = true;
                        _isCorrect = isCorrect;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Submit Answer',
                style: TextStyle(fontSize: 18),
              ),
            )
          else
            ElevatedButton(
              onPressed: () {
                if (_isCorrect) {
                  widget.onCorrect();
                } else {
                  widget.onWrong();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCorrect ? Colors.green : Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _isCorrect ? 'Next Question' : 'Try Next Question',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          if (_hasSubmitted)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _isCorrect
                    ? 'Great job! That\'s correct! 🎉'
                    : 'Oops! The correct answer is "$correctAnswer"',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}