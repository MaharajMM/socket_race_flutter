import 'package:flutter/material.dart';
import 'package:socket_race_flutter/socket_service.dart';
import 'package:socket_race_flutter/third_page.dart';

class Questions extends StatefulWidget {
  final int roomId;
  final Color backgroundColor;
  const Questions(
      {super.key, required this.roomId, required this.backgroundColor});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  //IO.Socket? socket;
  bool waiting = true;
  int currentQuestion = 0;
  int remainingTime = 10;
  List<dynamic> questions = [];
  //int count = 0;

  @override
  void initState() {
    super.initState();

    socket.on('waiting', (data) {
      if (data) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const AlertDialog(
            title: Text('Waiting for another player...'),
            content: Text('Please wait for another player to join the game.'),
          ),
        );
      } else {
        Navigator.pop(context);
        //showQuestion();
      }
    });

    // socket.on('question', (data) {
    //   setState(() {
    //     questions = data;
    //   });
    // });
    socket.on(
      'show_dialog',
      (data) => showDialog(
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
      ),
    );
    socket.on(
      'next_page',
      (data) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ThirdPage(
                  backgroundColor: Colors.amber,
                  roomId: widget.roomId,
                  userCount: 0,
                )),
      ),
    );

    socket.on(
      'userCount',
      (count) => {
        if (count == 1)
          {
            // Show "Please wait" dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Waiting for another player...'),
                content: const Text(
                    'Please wait for another player to join the game.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            )
          }
        else if (count == 2)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThirdPage(
                  backgroundColor: Colors.amber,
                  roomId: widget.roomId,
                  userCount: 0,
                ),
              ),
            ),
          }
      },
    );
  }

  void startGame() {
    socket.emit('join');
  }

  // @override
  // void dispose() {
  //   socket.disconnect();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text('Room ${widget.roomId}'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          socket.emit('userCount', {});
        },
        child: const Text("start Game"),
      )),
    );
  }
}
