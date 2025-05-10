import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learning/widgets/bouncing_button.dart';

class AudioQuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  const AudioQuestionWidget({
    super.key,
    required this.question,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  State<AudioQuestionWidget> createState() => _AudioQuestionWidgetState();
}

class _AudioQuestionWidgetState extends State<AudioQuestionWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = true;
  String? _selectedOption;
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  @override
  void didUpdateWidget(AudioQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      // Reset state when the question changes
      setState(() {
        _selectedOption = null;
        _hasSubmitted = false;
        _isCorrect = false;
        _isLoading = true;
        _errorMessage = null;
      });
      _initAudio();
    }
  }

  Future<void> _initAudio() async {
    final audioUrl = widget.question['audio'] as String?;
    if (audioUrl == null || audioUrl.isEmpty) {
      setState(() {
        _errorMessage = 'Audio file not available';
        _isLoading = false;
      });
      return;
    }

    try {
      // Dispose previous audio player instance if needed
      await _audioPlayer.stop();
      
      // Use a more reliable audio URL for testing if the original fails
      String urlToTry = audioUrl;
      
      // For testing purposes, if the URL is from soundjay.com (which might have CORS issues),
      // use a fallback URL
      if (audioUrl.contains('soundjay.com')) {
        if (audioUrl.contains('dog')) {
          urlToTry = 'https://assets.mixkit.co/sfx/preview/mixkit-dog-barking-twice-1.mp3';
        } else if (audioUrl.contains('cat')) {
          urlToTry = 'https://assets.mixkit.co/sfx/preview/mixkit-domestic-cat-hungry-meow-45.mp3';
        } else if (audioUrl.contains('cow')) {
          urlToTry = 'https://assets.mixkit.co/sfx/preview/mixkit-cow-moo-1744.mp3';
        }
      }
      
      await _audioPlayer.setUrl(urlToTry);
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load audio: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _playAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _checkAnswer() {
    if (_selectedOption == null) return;
    
    final correctAnswer = widget.question['answer'] as String;
    final isCorrect = _selectedOption == correctAnswer;
    
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = List<String>.from(widget.question['options'] ?? []);
    final correctAnswer = widget.question['answer'] as String? ?? '';
    
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
                  'Listen and choose the correct answer',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                if (_isLoading)
                  const CircularProgressIndicator()
                else if (_errorMessage != null)
                  Column(
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _initAudio,
                        child: const Text('Try Again'),
                      ),
                    ],
                  )
                else
                  BouncingButton(
                    onTap: _playAudio,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  _isPlaying ? 'Playing...' : 'Tap to play audio',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'What do you hear?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = _selectedOption == option;
                final isCorrectOption = option == correctAnswer;
                
                Color backgroundColor = Colors.white;
                Color borderColor = Colors.grey;
                
                if (_hasSubmitted) {
                  if (isCorrectOption) {
                    backgroundColor = Colors.green.withOpacity(0.2);
                    borderColor = Colors.green;
                  } else if (isSelected && !isCorrectOption) {
                    backgroundColor = Colors.red.withOpacity(0.2);
                    borderColor = Colors.red;
                  }
                } else if (isSelected) {
                  backgroundColor = Colors.blue.withOpacity(0.2);
                  borderColor = Colors.blue;
                }
                
                return BouncingButton(
                  onTap: _hasSubmitted ? null : () {
                    setState(() {
                      _selectedOption = option;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: _hasSubmitted && isCorrectOption
                              ? Colors.green[800]
                              : _hasSubmitted && isSelected && !isCorrectOption
                                  ? Colors.red[800]
                                  : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (!_hasSubmitted)
            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : _checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
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