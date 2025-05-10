import 'package:flutter/material.dart';
import 'package:learning/models/lesson_type.dart';
import 'package:learning/screens/lesson_screen.dart';
import 'package:learning/services/api_service.dart';
import 'package:learning/widgets/animated_background.dart';
import 'package:learning/widgets/bouncing_button.dart';

class GradeLessonsScreen extends StatefulWidget {
  final String grade;
  final String gradeLabel;

  const GradeLessonsScreen({
    super.key,
    required this.grade,
    required this.gradeLabel,
  });

  @override
  State<GradeLessonsScreen> createState() => _GradeLessonsScreenState();
}

class _GradeLessonsScreenState extends State<GradeLessonsScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    BouncingButton(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.gradeLabel,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Choose a lesson type to start learning!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(24),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      _buildLessonTypeCard(
                        context,
                        'Fill in the Blanks',
                        Icons.edit,
                        Colors.blue,
                        LessonType.fill,
                      ),
                      _buildLessonTypeCard(
                        context,
                        'Match Images',
                        Icons.image,
                        Colors.green,
                        LessonType.imageMatch,
                      ),
                      _buildLessonTypeCard(
                        context,
                        'Audio Quiz',
                        Icons.music_note,
                        Colors.orange,
                        LessonType.audio,
                      ),
                      _buildLessonTypeCard(
                        context,
                        'Form Sentences',
                        Icons.text_fields,
                        Colors.purple,
                        LessonType.sentence,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonTypeCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    LessonType type,
  ) {
    return BouncingButton(
      onTap: () async {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });

        try {
          final content = await ApiService().getCourseContent(widget.grade);

          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => LessonScreen(
                    lessonType: type,
                    content: content,
                    gradeLabel: widget.gradeLabel,
                  ),
            ),
          );
        } catch (e) {
          setState(() {
            _errorMessage = 'Failed to load content: $e';
          });
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
