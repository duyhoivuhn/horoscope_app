import 'package:flutter/material.dart';
import 'package:horoscope_app/home_page.dart';
import 'package:horoscope_app/splash_page.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'splash_page':
            return MaterialPageRoute(
              builder: (context) => SplashPage(),
              settings: settings,
            );
          case 'home_page':
            return PageRouteBuilder(
              settings: settings,
              pageBuilder:
                  (context, animation, secondaryAnimation) => const HomePage(),
              transitionDuration: const Duration(
                milliseconds: 500,
              ), // Ví dụ: 800ms
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          default:
            return MaterialPageRoute(
              builder: (context) => SplashPage(),
              settings: settings,
            );
        }
      },
      navigatorKey: navigator,
      initialRoute: 'splash_page',
    );
  }
}
