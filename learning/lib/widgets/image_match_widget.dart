import 'package:flutter/material.dart';
import 'package:learning/widgets/bouncing_button.dart';

class ImageMatchWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  const ImageMatchWidget({
    super.key,
    required this.question,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  State<ImageMatchWidget> createState() => _ImageMatchWidgetState();
}

class _ImageMatchWidgetState extends State<ImageMatchWidget> {
  String? _selectedImage;
  String? _selectedOption;
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  List<String> _remainingImages = [];
  List<String> _remainingOptions = [];
  int _matchedPairs = 0;
  int _totalPairs = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void didUpdateWidget(ImageMatchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _initializeGame();
    }
  }

  void _initializeGame() {
    final images = List<String>.from(widget.question['images'] ?? []);
    final options = List<String>.from(widget.question['options'] ?? []);
    final answers = Map<String, String>.from(widget.question['answers'] ?? {});
    
    _remainingImages = List.from(images);
    _remainingOptions = List.from(options);
    _totalPairs = answers.length;
    _matchedPairs = 0;
    _selectedImage = null;
    _selectedOption = null;
    _hasSubmitted = false;
    _isCorrect = false;
  }

  void _checkAnswer() {
    if (_selectedImage == null || _selectedOption == null) return;
    
    final answers = Map<String, String>.from(widget.question['answers'] ?? {});
    final correctOption = answers[_selectedImage];
    
    final isCorrect = correctOption == _selectedOption;
    
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
    });
    
    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _remainingImages.remove(_selectedImage);
            _remainingOptions.remove(_selectedOption);
            _selectedImage = null;
            _selectedOption = null;
            _hasSubmitted = false;
            _matchedPairs++;
            
            if (_remainingImages.isEmpty || _matchedPairs >= _totalPairs) {
              widget.onCorrect();
            }
          });
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _selectedImage = null;
            _selectedOption = null;
            _hasSubmitted = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Match the image with its correct name',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          if (_remainingImages.isNotEmpty)
            Expanded(
              child: Row(
                children: [
                  // Images column
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Images',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: _remainingImages.length,
                            itemBuilder: (context, index) {
                              final imageUrl = _remainingImages[index];
                              final isSelected = _selectedImage == imageUrl;
                              
                              return BouncingButton(
                                onTap: _hasSubmitted ? null : () {
                                  setState(() {
                                    _selectedImage = imageUrl;
                                    if (_selectedOption != null) {
                                      _checkAnswer();
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected ? Colors.blue : Colors.grey,
                                      width: isSelected ? 3 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Colors.red[300],
                                          ),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Options column
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Names',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _remainingOptions.length,
                            itemBuilder: (context, index) {
                              final option = _remainingOptions[index];
                              final isSelected = _selectedOption == option;
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: BouncingButton(
                                  onTap: _hasSubmitted ? null : () {
                                    setState(() {
                                      _selectedOption = option;
                                      if (_selectedImage != null) {
                                        _checkAnswer();
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected ? Colors.green : Colors.grey,
                                        width: isSelected ? 3 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Great job! You matched all the pairs!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: widget.onCorrect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 10),
          
          if (_remainingImages.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Matched: $_matchedPairs/$_totalPairs',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          if (_hasSubmitted)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _isCorrect ? 'Correct! Great job! 🎉' : 'Try again! That\'s not the right match.',
                style: TextStyle(
                  color: _isCorrect ? Colors.green[800] : Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}