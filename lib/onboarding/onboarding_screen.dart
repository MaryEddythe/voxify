import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:verbalize/onboarding/intro_page1.dart';
import 'package:verbalize/onboarding/intro_page2.dart';
import 'package:verbalize/onboarding/intro_page3.dart';
import 'package:verbalize/services/auth/authgate.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  PageController _controller = PageController();

  bool onLastPage = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

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


      Container(
        alignment: Alignment(0, 0.75),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [


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


            SmoothPageIndicator(controller: _controller, count: 3),


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