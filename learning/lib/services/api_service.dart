import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning/models/course_content.dart';

class ApiService {
  final String _baseUrl =
      'https://ai-qna-gvhkarb0faf3fvhs.eastus-01.azurewebsites.net';
  final String _authUrl =
      'https://sheshya-backend-f4gndddgadfhc3fy.eastus-01.azurewebsites.net';

  String? _authToken;

  Future<String> _getAuthToken() async {
    if (_authToken != null) return _authToken!;

    try {
      final response = await http.post(
        Uri.parse('$_authUrl/loginByEmailOrPhone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'testStudent@sheshya.in',
          'phone': '',
          'otp': '123456',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        return _authToken!;
      } else {
        throw Exception('Failed to get auth token: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, use mock data if API fails
      return 'mock_token';
    }
  }

  Future<CourseContent> getCourseContent(String className) async {
    try {
      final token = await _getAuthToken();

      final response = await http.post(
        Uri.parse('$_baseUrl/createCourseContent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'className': className}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CourseContent.fromJson(data);
      } else {
        throw Exception(
          'Failed to load course content: ${response.statusCode}',
        );
      }
    } catch (e) {
      // For demo purposes, return mock data if API fails
      return _getMockData(className);
    }
  }

  CourseContent _getMockData(String className) {
    // Mock data for demonstration purposes
    if (className == 'KG1') {
      return CourseContent(
        fill: [
          {
            'question': 'The color of the sky is _____.',
            'options': ['blue', 'green', 'red', 'yellow'],
            'answer': 'blue',
          },
          {
            'question': 'A _____ has four legs.',
            'options': ['fish', 'bird', 'dog', 'snake'],
            'answer': 'dog',
          },
          {
            'question': 'We use our _____ to see.',
            'options': ['ears', 'eyes', 'nose', 'mouth'],
            'answer': 'eyes',
          },
          {
            'question': 'The sun rises in the _____.',
            'options': ['south', 'west', 'north', 'east'],
            'answer': 'east',
          },
          {
            'question': 'We write with a _____.',
            'options': ['table', 'book', 'pencil', 'chair'],
            'answer': 'pencil',
          },
        ],
        imageMatch: [
          {
            'images': [
              'https://cdn-icons-png.flaticon.com/512/616/616430.png', // Cat
              'https://cdn-icons-png.flaticon.com/512/616/616438.png', // Bird
              'https://cdn-icons-png.flaticon.com/512/616/616412.png', // Lion
              'https://cdn-icons-png.flaticon.com/512/616/616408.png', // Dog
            ],
            'options': ['Dog', 'Cat', 'Lion', 'Bird'],
            'answers': {
              'https://cdn-icons-png.flaticon.com/512/616/616430.png': 'Cat',
              'https://cdn-icons-png.flaticon.com/512/616/616438.png': 'Bird',
              'https://cdn-icons-png.flaticon.com/512/616/616412.png': 'Lion',
              'https://cdn-icons-png.flaticon.com/512/616/616408.png': 'Dog',
            },
          },
        ],
        audio: [
          {
            'audio': 'assets/audio/dog-barking.mp3',
            'options': ['Dog', 'Cat', 'Cow', 'Bird'],
            'answer': 'Dog',
          },
          {
            'audio': 'assets/audio/cat-meow.mp3',
            'options': ['Lion', 'Cat', 'Tiger', 'Fox'],
            'answer': 'Cat',
          },
          {
            'audio': 'assets/audio/cow-mooing.mp3',
            'options': ['Horse', 'Sheep', 'Cow', 'Goat'],
            'answer': 'Cow',
          },
        ],
        sentence: [
          {
            'options': ['I', 'to', 'school', 'go', 'every day'],
            'answer': 'I go to school every day',
          },
          {
            'options': ['The', 'is', 'shining', 'sun', 'brightly'],
            'answer': 'The sun is shining brightly',
          },
          {
            'options': ['My', 'favorite', 'color', 'is', 'blue'],
            'answer': 'My favorite color is blue',
          },
        ],
      );
    } else if (className == '1') {
      return CourseContent(
        fill: [
          {
            'question': 'There are _____ days in a week.',
            'options': ['seven', 'five', 'ten', 'three'],
            'answer': 'seven',
          },
          {
            'question': 'The opposite of hot is _____.',
            'options': ['nice', 'warm', 'cool', 'cold'],
            'answer': 'cold',
          },
          {
            'question': '2 + 3 = _____.',
            'options': ['9', '5', '6', '7'],
            'answer': '5',
          },
          {
            'question': 'A _____ is used to tell time.',
            'options': ['pen', 'book', 'clock', 'shoe'],
            'answer': 'clock',
          },
          {
            'question': 'Water is a _____.',
            'options': ['vapour', 'solid', 'gas', 'liquid'],
            'answer': 'liquid',
          },
        ],
        imageMatch: [
          {
            'images': [
              'https://cdn-icons-png.flaticon.com/512/3082/3082383.png', // Maps
              'https://cdn-icons-png.flaticon.com/512/3082/3082371.png', // Microphone
              'https://cdn-icons-png.flaticon.com/512/3082/3082377.png', // Camera
              'https://cdn-icons-png.flaticon.com/512/3082/3082376.png', // Home
            ],
            'options': ['Microphone', 'Home', 'Camera', 'Home'],
            'answers': {
              'https://cdn-icons-png.flaticon.com/512/3082/3082383.png': 'Maps',
              'https://cdn-icons-png.flaticon.com/512/3082/3082371.png':
                  'Microphone',
              'https://cdn-icons-png.flaticon.com/512/3082/3082377.png':
                  'Camera',
              'https://cdn-icons-png.flaticon.com/512/3082/3082376.png': 'Home',
            },
          },
        ],
        audio: [
          {
            'audio': 'assets/audio/duck-quack.mp3',
            'options': ['Rooster', 'Duck', 'Chicken', 'Turkey'],
            'answer': 'Duck',
          },
          {
            'audio': 'assets/audio/bird.mp3',
            'options': ['Bird', 'Frog', 'Cricket', 'Bee'],
            'answer': 'Bird',
          },
          {
            'audio': 'assets/audio/wolf-howl.mp3',
            'options': ['Wolf', 'Dog', 'Coyote', 'Fox'],
            'answer': 'Wolf',
          },
        ],
        sentence: [
          {
            'options': ['I', 'like', 'to', 'read', 'books'],
            'answer': 'I like to read books',
          },
          {
            'options': ['The', 'cat', 'is', 'sleeping', 'on', 'the', 'bed'],
            'answer': 'The cat is sleeping on the bed',
          },
          {
            'options': ['We', 'go', 'to', 'the', 'park', 'on', 'Sunday'],
            'answer': 'We go to the park on Sunday',
          },
        ],
      );
    } else {
      return CourseContent(
        fill: [
          {
            'question': 'The Earth rotates around the _____.',
            'options': ['Mars', 'Moon', 'Sun', 'Jupiter'],
            'answer': 'Sun',
          },
          {
            'question': 'Plants make food using _____.',
            'options': ['air', 'water', 'soil', 'sunlight'],
            'answer': 'sunlight',
          },
          {
            'question': '10 - 4 = _____.',
            'options': ['1', '6', '7', '4'],
            'answer': '6',
          },
          {
            'question': 'A _____ is a place where books are kept.',
            'options': ['park', 'school', 'hospital', 'library'],
            'answer': 'library',
          },
          {
            'question': 'We breathe in _____ and breathe out carbon dioxide.',
            'options': ['helium', 'nitrogen', 'hydrogen', 'oxygen'],
            'answer': 'oxygen',
          },
        ],
        imageMatch: [
          {
            'images': [
              'https://cdn-icons-png.flaticon.com/512/3313/3313480.png', // Graduate
              'https://cdn-icons-png.flaticon.com/512/3313/3313461.png', // Airplane
              'https://cdn-icons-png.flaticon.com/512/3313/3313544.png', // Wheel
              'https://cdn-icons-png.flaticon.com/512/3313/3313471.png', // Bed
            ],
            'options': ['Bed', 'Airplane', 'Graduate', 'Airplane'],
            'answers': {
              'https://cdn-icons-png.flaticon.com/512/3313/3313480.png':
                  'Graduate',
              'https://cdn-icons-png.flaticon.com/512/3313/3313461.png':
                  'Airplane',
              'https://cdn-icons-png.flaticon.com/512/3313/3313544.png':
                  'Wheel',
              'https://cdn-icons-png.flaticon.com/512/3313/3313471.png': 'Bed',
            },
          },
        ],
        audio: [
          {
            'audio': 'assets/audio/elephant.mp3',
            'options': ['Elephant', 'Rhino', 'Hippo', 'Giraffe'],
            'answer': 'Elephant',
          },
          {
            'audio': 'assets/audio/lion-roar.mp3',
            'options': ['Lion', 'Tiger', 'Leopard', 'Jaguar'],
            'answer': 'Lion',
          },
          {
            'audio': 'assets/audio/horse-whinny.mp3',
            'options': ['Horse', 'Donkey', 'Zebra', 'Pony'],
            'answer': 'Horse',
          },
        ],
        sentence: [
          {
            'options': ['The', 'Earth', 'is', 'round', 'and', 'beautiful'],
            'answer': 'The Earth is round and beautiful',
          },
          {
            'options': ['We', 'should', 'protect', 'our', 'environment'],
            'answer': 'We should protect our environment',
          },
          {
            'options': ['Reading', 'books', 'makes', 'us', 'smarter'],
            'answer': 'Reading books makes us smarter',
          },
        ],
      );
    }
  }
}
