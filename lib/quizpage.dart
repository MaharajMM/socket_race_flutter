import 'package:flutter/material.dart';
import 'package:socket_race_flutter/third_page.dart';
import 'package:socket_race_flutter/socket_service.dart';

class QuizPage extends StatefulWidget {
  final int roomId;
  //final String roomUuid;
  final Color backgroundColor;
  //final String data;
  //final io.Socket socket;

  const QuizPage({
    Key? key,
    required this.roomId,
    // required this.roomUuid,
    required this.backgroundColor,
    // required this.data,
    //required this.socket,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // final bool _isReady = false;
  // final bool _quizStarted = false;
  late String message;
  String ready = "Ready";
  bool isButtonEnabled = false;
  bool isQuizStarted = false;
  int userCount = 0;
  late int roomId;

  @override
  void initState() {
    //widget.socket.on('showMessage', (data) => _showDialog());
    //WidgetsBinding.instance.addPostFrameCallback((_) => _showDialog());
    print("2nd page");
    super.initState();
    socket.on('quizStarted', (data) {
      setState(() {
        isQuizStarted = true;
        isButtonEnabled = true;
      });
    });

    print("2nd page 2");
    socket.on('showMessage', _showDialog);
    socket.on('show_dialog', _showDialog);
    socket.on('userCount', handleUserCount);
  }

  void handleUserCount(dynamic data) {
    userCount = data['memberCount'];

    if (userCount == 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Waiting for another player...'),
          content:
              const Text('Please wait for another player to join the game.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThirdPage(
            roomId: roomId,
            backgroundColor: Colors.purple,
            userCount: 1,
          ),
        ),
      );
    }
  }

  void _showDialog(dynamic msg) {
    print("object");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Started'),
          content: Text('The quiz has started in $msg'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onStartQuizPressed() {
    socket.emit('startQuiz', {widget.roomId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.backgroundColor, // Set the background color for the page
      appBar: AppBar(
        title: Text('Room ${widget.roomId}'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _onStartQuizPressed();
              },
              child: const Text('Start Quiz'),
            ),
            Text(
              'You are in room ${widget.roomId}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
