import 'package:flutter/material.dart';
import 'package:learning/widgets/bouncing_button.dart';

class SentenceQuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  const SentenceQuestionWidget({
    super.key,
    required this.question,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  State<SentenceQuestionWidget> createState() => _SentenceQuestionWidgetState();
}

class _SentenceQuestionWidgetState extends State<SentenceQuestionWidget> {
  List<String> _selectedWords = [];
  List<String> _availableWords = [];
  bool _hasSubmitted = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void didUpdateWidget(SentenceQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _initializeGame();
    }
  }

  void _initializeGame() {
    final options = List<String>.from(widget.question['options'] ?? []);
    _availableWords = List.from(options);
    _availableWords.shuffle(); // Randomize the order
    _selectedWords = [];
    _hasSubmitted = false;
    _isCorrect = false;
  }

  void _addWord(String word) {
    setState(() {
      _selectedWords.add(word);
      _availableWords.remove(word);
    });
  }

  void _removeWord(int index) {
    setState(() {
      _availableWords.add(_selectedWords[index]);
      _selectedWords.removeAt(index);
    });
  }

  void _checkAnswer() {
    final correctSentence = widget.question['answer'] as String;
    final userSentence = _selectedWords.join(' ');
    
    final isCorrect = userSentence.trim() == correctSentence.trim();
    
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
    });
  }

  void _resetSentence() {
    setState(() {
      _initializeGame();
      _hasSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final correctSentence = widget.question['answer'] as String;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
                  'Form a correct sentence',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.purple[800],
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _hasSubmitted
                          ? (_isCorrect ? Colors.green : Colors.red)
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minHeight: 100,
                  ),
                  child: _selectedWords.isEmpty
                      ? const Center(
                          child: Text(
                            'Tap words below to form a sentence',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            _selectedWords.length,
                            (index) => BouncingButton(
                              onTap: _hasSubmitted ? null : () => _removeWord(index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.purple),
                                ),
                                child: Text(
                                  _selectedWords[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Available words:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _availableWords.isEmpty
                ? Center(
                    child: Text(
                      'All words have been used',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _availableWords.map((word) {
                      return BouncingButton(
                        onTap: _hasSubmitted ? null : () => _addWord(word),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(word),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 20),
          if (!_hasSubmitted)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _selectedWords.isEmpty ? null : _resetSentence,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedWords.isEmpty ? null : _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Submit'),
                ),
              ],
            )
          else
            Column(
              children: [
                if (!_isCorrect)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Correct sentence: "$correctSentence"',
                      style: TextStyle(
                        color: Colors.red[800],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!_isCorrect)
                      ElevatedButton.icon(
                        onPressed: _resetSentence,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (_isCorrect) {
                          widget.onCorrect();
                        } else {
                          widget.onWrong();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCorrect ? Colors.green : Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text(_isCorrect ? 'Next Question' : 'Next Question'),
                    ),
                  ],
                ),
              ],
            ),
          if (_hasSubmitted && _isCorrect)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Great job! That\'s correct! 🎉',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}