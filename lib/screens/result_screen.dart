import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/screens/homepage.dart';
import '../controllers/question_controller.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../network/point.dart';


class ResultScreen extends StatefulWidget {
  final String gameId;
  final String eventId;
  const ResultScreen({Key? key, required this.gameId, required this.eventId}) : super(key: key);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final QuestionController _qnController = Get.find<QuestionController>();
  late ConfettiController _confettiController;
  bool _isUpdatingPoints = false;
  int _earnedPoints = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
    _updateUserPoints();
  }

  Future<void> _updateUserPoints() async {
    setState(() {
      _isUpdatingPoints = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken['id'] as String;

    // Calculate points based on correct answers
    _earnedPoints = _qnController.numOfCorrectAns * 10; // Assuming 10 points per correct answer

    try {
      bool success = await PointRequest.updatePoint(userId, widget.gameId, widget.eventId, _earnedPoints, _earnedPoints);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã cộng thêm $_earnedPoints điểm!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra khi cập nhật điểm.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    } finally {
      setState(() {
        _isUpdatingPoints = false;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/icons/bg.svg",
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Quiz Result",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${_qnController.numOfCorrectAns}/${_qnController.questions.length}",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Correct Answers",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 20),
                      _isUpdatingPoints
                          ? CircularProgressIndicator()
                          : Text(
                              "Earned Points: $_earnedPoints",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  child: Text('Go to Home'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Get.offAll(() => HomePage());
                  },
                ),
              ],
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}