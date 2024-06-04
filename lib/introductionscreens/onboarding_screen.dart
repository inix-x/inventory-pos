import 'package:flutter/material.dart';
import 'package:flutter_application_1/introductionscreens/intropage1.dart';
import 'package:flutter_application_1/introductionscreens/intropage2.dart';
import 'package:flutter_application_1/introductionscreens/intropage3.dart';
import 'package:flutter_application_1/loginwidget/loginpage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const OnboardingScreen());
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with onPageChanged callback
          PageView(
            controller: _controller,
            onPageChanged: (int index) {
              setState(() {
                onLastPage = (index == 2); // Update UI based on current page (optional)
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          // Dot indicator connected to PageController
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text('Skip')
                  ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const WormEffect(
                    dotHeight: 16,
                    dotWidth: 16,
                    type: WormType.thinUnderground,
                  ),
                ),

                //next or done
                onLastPage ? GestureDetector(
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context){
                    return  const LoginScreen();
                   }));
                  },
                  child: const Text('Done'),
                ) : GestureDetector(
                  onTap: () {
                    _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  },
                  child: const Text('Next'),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
