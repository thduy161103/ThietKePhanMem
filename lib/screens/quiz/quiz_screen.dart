import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/controllers/question_controller.dart';

import 'components/body.dart';

class QuizScreen extends StatelessWidget {
  final String eventId;
  final String gameId;

  const QuizScreen({Key? key, required this.eventId, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: Body(eventId: eventId, gameId: gameId),
    );
  }
}
