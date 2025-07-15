import 'package:flutter/material.dart';
void main() => runApp(QuizifyApp());
class QuizifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizify',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
const profile = {
  'name': 'Harry Potter',
  'email': 'Potter.H@email.com',
  'phone': '+1234567890'
};
final List<Map<String, Object>> questions = [
  {
    'question': 'What is the first letter of the word "unbelievability"?',
    'answers': ['u', 'n', 'e', 'b'],
    'correct': 0
  },
  {
    'question': 'What is the second letter of the word "unbelievability"?',
    'answers': ['u', 'l', 'n', 'a'],
    'correct': 2
  },
  {
    'question': 'What is the third letter of the word "unbelievability"?',
    'answers': ['l', 'b', 'e', 'i'],
    'correct': 1
  },
  {
    'question': 'What is the fourth letter of the word "unbelievability"?',
    'answers': ['i', 'v', 'e', 't'],
    'correct': 2
  },
  {
    'question': 'What is the fifth letter of the word "unbelievability"?',
    'answers': ['b', 'l', 'u', 'y'],
    'correct': 1
  },
  {
    'question': 'What is the sixth letter of the word "unbelievability"?',
    'answers': ['e', 'a', 'i', 'n'],
    'correct': 2
  },
  {
    'question': 'What is the seventh letter of the word "unbelievability"?',
    'answers': ['e', 'v', 't', 'b'],
    'correct': 0
  },
  {
    'question': 'What is the eighth letter of the word "unbelievability"?',
    'answers': ['y', 'l', 'e', 'v'],
    'correct': 3
  },
  {
    'question': 'What is the ninth letter of the word "unbelievability"?',
    'answers': ['a', 'n', 'b', 'l'],
    'correct': 0
  },
  {
    'question': 'What is the tenth letter of the word "unbelievability"?',
    'answers': ['e', 'v', 'b', 'i'],
    'correct': 2
  },
];
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quizify Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(child: Icon(Icons.person, size: 60), radius: 60),
            SizedBox(height: 24),
            Text('Name: ${profile['name']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Email: ${profile['email']}', style: TextStyle(fontSize: 22)),
            Text('Phone: ${profile['phone']}', style: TextStyle(fontSize: 22)),
            SizedBox(height: 40),
            ElevatedButton(
              child: Text('Start Quiz', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QuizScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}
class _QuizScreenState extends State<QuizScreen> {
  int questionIndex = 0;
  List<int?> selectedAnswers = List.filled(questions.length, null);
  int getScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['correct']) score++;
    }
    return score;
  }
  int getCorrect() => getScore();

  int getIncorrect() {
    int incorrect = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] != null &&
          selectedAnswers[i] != questions[i]['correct']) incorrect++;
    }
    return incorrect;
  }
  int getUnattempted() {
    return selectedAnswers.where((e) => e == null).length;
  }
  void nextQuestion() {
    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
      });
    }
  }
  void prevQuestion() {
    if (questionIndex > 0) {
      setState(() {
        questionIndex--;
      });
    }
  }
  void selectAnswer(int selected) {
    setState(() {
      selectedAnswers[questionIndex] = selected;
    });
  }
  void showResultDialog(BuildContext context) {
    int score = getScore();
    int correct = getCorrect();
    int incorrect = getIncorrect();
    int unattempted = getUnattempted();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your Score',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '$score / ${questions.length}',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildResultStatus('Correct', correct, Colors.green),
                  _buildResultStatus('Incorrect', incorrect, Colors.red),
                  _buildResultStatus('Unattempted', unattempted, Colors.grey),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Go to Home', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultStatus(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    var q = questions[questionIndex];
    var answers = q['answers'] as List<String>;
    int? selected = selectedAnswers[questionIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Q${questionIndex + 1} of ${questions.length}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14),
            Text(
              q['question'] as String,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ...answers.asMap().entries.map((entry) {
              final idx = entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: selected == idx ? Colors.blue.shade50 : Colors.grey.shade100,
                  title: Text(entry.value, style: TextStyle(fontSize: 18)),
                  leading: Radio<int>(
                    value: idx,
                    groupValue: selected,
                    onChanged: (value) => selectAnswer(value!),
                  ),
                  onTap: () => selectAnswer(idx),
                ),
              );
            }),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: prevQuestion,
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: questionIndex < questions.length - 1 ? nextQuestion : null,
                  child: Text('Next'),
                ),
              ],
            ),
            if (questionIndex == questions.length - 1)
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: ElevatedButton(
                  onPressed: () => showResultDialog(context),
                  child: Text('Final Submit', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
