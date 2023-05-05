import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_race_flutter/result.dart';
import 'package:socket_race_flutter/socket_service.dart';

class ThirdPage extends StatefulWidget {
  final int roomId;
  final Color backgroundColor;
  final int userCount;

  const ThirdPage(
      {super.key,
      required this.roomId,
      required this.backgroundColor,
      required this.userCount});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  int currentIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  int _user1Score = 0;
  int _user2Score = 0;
  late int user1, user2;
  List<dynamic> questions = [];
  String selectedAnswer = '';
  bool user = true;

  @override
  void initState() {
    super.initState();

    socket.on('answered', handleQuestion);
    //socket.on('nextQuestion', handleNextQuestion);
    // Fetch the questions from the backend
    //socket.on('user', (user) => {user ? user = true : user = false});
    socket.on('score', handleScore);
    fetchQuestions();
  }

  void handleScore(dynamic data) {
    user1 = data['user1'];
    user2 = data['user2'];
  }

  void handleQuestion(dynamic data) {
    if (data['roomId'] == widget.roomId) {
      if (questions[currentIndex]['answer'] == selectedAnswer) {
        //print('if2');
        //socket.emit('score', 'user1');
        setState(() {
          if (user) {
            socket.emit('score', 'user1');
            _user1Score++;
            print('_user1Score $_user1Score');
          } else {
            _user2Score++;
            socket.emit('score', 'user2');
            print('_user2Score if $_user2Score');
          }
          //user = !user;
          _isAnswered = true;
          _isCorrect = true;
          //user = data['user'];
        });
      } else {
        setState(() {
          if (user) {
            socket.emit('score', 'user2');
            _user2Score++;
            print('_user2Score else $_user2Score');
          } else {
            socket.emit('score', 'user1');
            _user1Score++;
            print('_user1Score $_user1Score');
          }
          //user = !user;
          _isAnswered = true;
          _isCorrect = false;
          //user = data['user'];
        });
      }

      // Wait for 1 second and move to the next question
      Future.delayed(const Duration(seconds: 1), () {
        if (currentIndex == questions.length - 1) {
          // Navigate to the results screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResultPage(
                user1Score: _user1Score,
                user2Score: _user2Score,
              ),
            ),
          );
        } else {
          setState(() {
            currentIndex++;
            _isAnswered = false;
            //user = !user;
          });
        }
      });
    }
  }

  void _sendEmit(String selectedIndex) {
    socket.emit('answered', {
      'roomId': widget.roomId,
      //'userAnswer': selectedIndex,
    });
  }

  Future<void> fetchQuestions() async {
    // Make a request to the backend to fetch the questions
    final response = await http.get(Uri.parse(
        'https://wayyanna.up.railway.app/questions/question_catwise/1?language=E'));

    //print('response: ${response.body}');

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response and return the questions
      Map<String, dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> apiResponseFormatted =
          List<Map<String, dynamic>>.from(data['data']);
      // print("apiResponseFormatted: $apiResponseFormatted");
      setState(() {
        questions = apiResponseFormatted;
      });
    } else {
      // If the request fails, throw an error
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('questions: $questions');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Screen'),
      ),
      body: SafeArea(
        child: Center(
          child: questions == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        questions[currentIndex]['question_text'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: _isAnswered
                              ? null
                              : () {
                                  //_checkAnswer('opt${index + 1}');
                                  //socket.emit('answered', {});
                                  selectedAnswer = 'opt${index + 1}';
                                  _sendEmit(selectedAnswer);

                                  //print('opt${index + 1}');
                                },
                          child:
                              Text(questions[currentIndex]['opt${index + 1}']),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isAnswered
                        ? user
                            ? _isCorrect
                                ? const Icon(Icons.check,
                                    color: Colors.green, size: 48)
                                : const Icon(Icons.close,
                                    color: Colors.red, size: 48)
                            : Container()
                        : Container()
                  ],
                ),
        ),
      ),
    );
  }
}
