import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/question_controller.dart';
import 'package:flutter_svg/svg.dart';

import 'progress_bar.dart';
import 'question_card.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController _questionController = Get.put(QuestionController());
    return Stack(
      children: [
        SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
        SafeArea(
          child: Obx(() {
            if (_questionController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (_questionController.questions.isEmpty) {
              return Center(child: Text("No questions available"));
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: ProgressBar(),
                  ),
                  SizedBox(height: kDefaultPadding),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Text.rich(
                      TextSpan(
                        text: "Question ${_questionController.questionNumber.value}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: kSecondaryColor),
                        children: [
                          TextSpan(
                            text: "/${_questionController.questions.length}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: kSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 1.5),
                  SizedBox(height: kDefaultPadding),
                  Expanded(
                    child: PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _questionController.pageController,
                      onPageChanged: _questionController.updateTheQnNum,
                      itemCount: _questionController.questions.length,
                      itemBuilder: (context, index) => QuestionCard(
                        question: _questionController.questions[index],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ],
    );
  }
}
