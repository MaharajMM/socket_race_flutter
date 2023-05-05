import 'package:flutter/material.dart';
import 'package:socket_race_flutter/third_page.dart';
import 'package:socket_race_flutter/socket_service.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  //IO.Socket socket;
  int? userCount;
  late int roomId;

  @override
  void initState() {
    super.initState();
    socket.connect();
    // Connect to the server
    // Listen for the "message" event from the server
    socket.on('message', (data) {
      print('Received message from server: $data');
    });

    socket.on('room-joined', (data) {
      roomId = data['roomId'];
      final roomUuid = data['roomUuid'];
      print('Joined room $roomId with UUID $roomUuid');
      // Check the user count of the room
    });
    socket.on(
      "navigateToNextScreen",
      (data) => {
        Navigator.of(context).pop(),
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThirdPage(
              backgroundColor: Colors.teal,
              roomId: roomId,
              userCount: userCount!,
            ),
          ),
        ),
      },
    );

// Listen for the "userCount" event from the server
    socket.on('userCount', (count) {
      //userCount = data['userCount'];
      print('User count: $count');
      userCount ??= count;
      if (count == 1) {
        // Show "Please wait" dialog
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Please wait'),
            content: Text('Waiting for another user to join the room...'),
          ),
        );
      }
    });

    socket.emit('userCount', {});
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // Disconnect from the server when the widget is disposed
  //   socket.disconnect();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Send a "join-room" event to the server when the button is pressed
            socket.emit('join-room', {});
          },
          child: const Text('Join Room'),
        ),
      ),
    );
  }
}
