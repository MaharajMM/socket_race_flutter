import 'package:flutter/material.dart';
import 'package:socket_race_flutter/quizpage.dart';
import 'package:socket_race_flutter/socket_service.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  //late IO.Socket socket;
  //late final List<String> _players = [];
  late int roomId;
  String roomUuid = '';
  //bool quizStarted = false;
  // List<Question> questions = [];
  //int currentQuestionIndex = 0;
  // int? score;

  String message = '';
  // Timer? timer;

  @override
  void initState() {
    super.initState();
    // Initialize the socket
    // socket =
    //     IO.io('https://socketrace-production.up.railway.app', <String, dynamic>{
    //   'transports': ['websocket'],
    // });
    socket.on('connection', (_) => print('connected'));
    socket.on('disconnect', (_) => print('disconnected'));
    // Listen for events from the server

    socket.on('room-joined', handleRoomJoined);

    socket.on('message', (msg) {
      message = msg;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: const Text('Room Created'),
            content: Text('Received message: $message'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });

    // socket.on('startQuiz', (data) {
    //   List<dynamic> questions = data;
    //   // display questions to user
    // });
  }

  @override
  void dispose() {
    // Disconnect the socket when the widget is disposed
    socket.disconnect();
    super.dispose();
  }

  void _onJoinRoomPressed() {
    socket.emit('join-room', {});
    // When the server responds with the new room object
  }

  void handleRoomJoined(dynamic data) {
    roomId = data['roomId'];
    roomUuid = data['roomUuid'];
    // Handle the room created event

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          roomId: roomId,
          backgroundColor: Colors.purple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  _onJoinRoomPressed();
                },
                child: const Text('Join Room'),
              ),
              ElevatedButton(
                onPressed: () {
                  // _onMesssagePass();
                },
                child: const Text('Create Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
