import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/question_controller.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QuestionController _qnController = Get.find<QuestionController>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Quiz Result",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            Text(
              "You got ${_qnController.numOfCorrectAns} out of ${_qnController.questions.length} questions correct!",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              child: Text('Go to Home'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}