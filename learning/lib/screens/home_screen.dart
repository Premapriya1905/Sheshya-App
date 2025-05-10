import 'package:flutter/material.dart';
import 'package:learning/screens/grade_lessons_screen.dart';
import 'package:learning/widgets/animated_background.dart';
import 'package:learning/widgets/bouncing_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/2436/2436636.png',
                  height: 120,
                ),
                const SizedBox(height: 20),
                Text(
                  'Learning Adventure',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Hello! Welcome to our fun learning adventure! 🎉\nLet\'s explore and learn together!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Choose your grade:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGradeButton(context, 'Kindergarten', 'KG1'),
                      _buildGradeButton(context, '1st Grade', '1'),
                      _buildGradeButton(context, '2nd Grade', '2'),
                    ],
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '© 2023 Learning Adventure',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradeButton(BuildContext context, String label, String grade) {
    return BouncingButton(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GradeLessonsScreen(grade: grade, gradeLabel: label),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: grade == 'KG1'
              ? Colors.pink[100]
              : grade == '1'
                  ? Colors.blue[100]
                  : Colors.green[100],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              grade == 'KG1'
                  ? Icons.child_care
                  : grade == '1'
                      ? Icons.looks_one
                      : Icons.looks_two,
              size: 40,
              color: grade == 'KG1'
                  ? Colors.pink[700]
                  : grade == '1'
                      ? Colors.blue[700]
                      : Colors.green[700],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: grade == 'KG1'
                    ? Colors.pink[700]
                    : grade == '1'
                        ? Colors.blue[700]
                        : Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}