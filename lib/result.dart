import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int user1Score;
  final int user2Score;

  const ResultPage({
    Key? key,
    required this.user1Score,
    required this.user2Score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            Text('User1 score: $user1Score'),
            Text('User2 score: $user2Score'),
          ],
        ),
      ),
    );
  }
}
