import 'package:flutter/material.dart';
import 'package:frontend/features/Boarding/screens/boarding_screen_builder.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/themes/app_themes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../features/auth/screens/login/login_screen.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  BoardingScreenState createState() => BoardingScreenState();
}

class BoardingScreenState extends State<BoardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  final pages = BoardingScreenBuilder.pageviewBuilder;

  void _skip() {
    _newPage();
  }

  void _onNext() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _newPage();
    }
  }

  void _newPage() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: pages.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final items = pages[index];
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 85),
                      Image.asset(
                        items['image'],
                        height: 348,
                        width: 413,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 35),
                      Text(
                        items['title'],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 60),
                      Text(
                        items['description'],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 90),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: TextButton(
                    onPressed: () {
                      _skip();
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(color: AppColors.redColor, fontSize: 17),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: TextButton(
                    onPressed: () {
                      _onNext();
                    },
                    child: Text(
                      currentIndex <pages.length-1? "Next"
            : "Finish",
                      style: TextStyle(color: AppColors.primary, fontSize: 17),
                    ),
                  ),
                ),
                Positioned(
                  left: 170,
                  bottom: 30,
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      dotColor: AppColors.grey,
                      activeDotColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
