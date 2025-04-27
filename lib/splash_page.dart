import 'package:flutter/material.dart';
import 'package:horoscope_app/home_page.dart';
import 'package:horoscope_app/main.dart';

import 'gen/assets.gen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Đợi một khoảng thời gian (ví dụ: 3 giây)
    await Future.delayed(Duration(seconds: 1), () {});
    navigator.currentState?.pushReplacementNamed('home_page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Hero(
          tag: 'appLogo',
          child: Assets.images.splash.image(
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
