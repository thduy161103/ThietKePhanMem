import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/environment.dart';
import '../models/question.dart';
import '../screens/result_screen.dart';

class QuestionController extends GetxController with SingleGetTickerProviderMixin {
  final String eventId;
  final String gameId;

  QuestionController({required this.eventId, required this.gameId}) {
    print("QuestionController initialized with eventId: $eventId");
  }

  late AnimationController _animationController;
  late Animation<double> _animation;
  Animation<double> get animation => _animation;

  late PageController _pageController;
  PageController get pageController => _pageController;

  RxList<Question> _questions = <Question>[].obs;
  List<Question> get questions => _questions;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  late String _correctAns;
  String get correctAns => _correctAns;

  late String _selectedAns;
  String get selectedAns => _selectedAns;

  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _animationController = AnimationController(duration: Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        update();
      });

    _pageController = PageController();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    print("Fetching questions for eventId: $eventId");
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jwtToken = prefs.getString('accessToken');

      if (jwtToken == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.get(
        Uri.parse('${Environment.baseUrl}/brand/api/event/fetchquestion/$eventId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data.containsKey('_questions') && data['_questions'] is List) {
          _questions.value = (data['_questions'] as List)
              .map((json) => Question.fromJson(json))
              .toList();
          print('Parsed questions: $_questions');
          isLoading.value = false;
          if (_questions.isNotEmpty) {
            _animationController.forward().whenComplete(nextQuestion);
          }
          update();
        } else {
          throw Exception('Invalid data format or unsuccessful response');
        }
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print('Error fetching questions: $e');
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _animationController.dispose();
    _pageController.dispose();
    super.onClose();
  }

  void checkAns(Question question, String selectedAnswer) {
    // Don't allow changing the answer if already answered
    if (_isAnswered) return;
    
    _isAnswered = true;
    _correctAns = question.correctAnswer;
    _selectedAns = selectedAnswer;

    if (_correctAns == _selectedAns) {
      _numOfCorrectAns++;
    }

    _animationController.stop();
    update();

    // Add a delay before moving to the next question or ending the quiz
    Future.delayed(Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber.value != questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
        duration: Duration(milliseconds: 250),
        curve: Curves.ease,
      );
      _animationController.reset();
      _animationController.forward().whenComplete(() {
        if (_questionNumber.value == questions.length) {
          _animationController.stop();
          Get.off(() => ResultScreen(gameId: gameId, eventId: eventId));
        }
      });
    } else {
      _animationController.stop();
      Get.off(() => ResultScreen(gameId: gameId, eventId: eventId));
    }
  }

  // Remove the showResultDialog method as it's no longer needed

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    print("Question number updated: ${_questionNumber.value}");
    // Remove the navigation to score screen from here
  }
}