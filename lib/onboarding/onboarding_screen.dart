import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:verbalize/onboarding/intro_page1.dart';
import 'package:verbalize/onboarding/intro_page2.dart';
import 'package:verbalize/onboarding/intro_page3.dart';
import 'package:verbalize/page/login.dart';
import 'package:verbalize/services/auth/authgate.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  //controller pages where diin na ang user//
  PageController _controller = PageController();

  //keep track if we are on the last page//
  bool onLastPage = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //page view//
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index ==  2);
              });
            },
        children: [
          IntroPage1(),
          IntroPage2(),
          IntroPage3(),
        ],
      ),

      //dot indicator//
      Container(
        alignment: Alignment(0, 0.75),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            //skip//
            GestureDetector(
              onTap: () {
                _controller.nextPage(
                  duration: Duration(milliseconds: 500), 
                  curve: Curves.easeIn);
              },
              child: 
              GestureDetector(
                onTap: () {
                  _controller.jumpToPage(2);
                },
                child: Text('skip'),
                ),
              ),

            //dot indicator//
            SmoothPageIndicator(controller: _controller, count: 3),

            //para sa next or done//
            onLastPage ?
            GestureDetector(
                onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (conetxt) {
                  return AuthGate();
                }));
              },
              child: Text('done'),
            )

             : GestureDetector(
                onTap: () {
                _controller.nextPage(
                  duration: Duration(milliseconds: 500), 
                  curve: Curves.easeIn);
              },
              child: Text('next'),
            ),
          ],
        ),),
        ],
      )
    );
  }
}