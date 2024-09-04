import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/question_controller.dart';
import '../../../models/question.dart';
import '../../../constants.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  const QuestionCard({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.find<QuestionController>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black, // Ensure text is visible
              fontWeight: FontWeight.bold, // Make text bolder
            ),
          ),
          SizedBox(height: 20),
          ...List.generate(
            question.answers.length,
            (index) => Option(
              index: index,
              text: question.answers[index],
              press: () {
                if (!_controller.isAnswered) {
                  _controller.checkAns(question, question.answers[index]);
                  // Add a delay before moving to the next question
                  Future.delayed(Duration(seconds: 2), () {
                    _controller.nextQuestion();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Option extends StatelessWidget {
  const Option({
    Key? key,
    required this.text,
    required this.index,
    required this.press,
  }) : super(key: key);
  final String text;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      builder: (qnController) {
        Color getTheRightColor() {
          if (qnController.isAnswered) {
            if (text == qnController.correctAns) {
              return Colors.green;
            } else if (text == qnController.selectedAns &&
                qnController.selectedAns != qnController.correctAns) {
              return Colors.red;
            }
          }
          return Colors.grey.shade300;
        }

        IconData getTheRightIcon() {
          return getTheRightColor() == Colors.red ? Icons.close : Icons.done;
        }

        return InkWell(
          onTap: press,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: getTheRightColor()),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${index + 1}. $text",
                  style: TextStyle(
                    color: getTheRightColor(),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: getTheRightColor() == Colors.grey.shade300
                        ? Colors.transparent
                        : getTheRightColor(),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: getTheRightColor()),
                  ),
                  child: getTheRightColor() == Colors.grey.shade300
                      ? null
                      : Icon(getTheRightIcon(), size: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
