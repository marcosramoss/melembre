import 'package:flutter/material.dart';
import 'package:melembre/pages/HomePage.dart';
import 'package:flutter/services.dart';
import 'package:melembre/pages/splash_page.dart';

main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MeLembreApp());
}

class MeLembreApp extends StatelessWidget {
  const MeLembreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurpleAccent[400],
          secondary: Colors.deepPurpleAccent[400],
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashPage(),
        'home': (_) => const HomePage(),
      },
    );
  }
}
