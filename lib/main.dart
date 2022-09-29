import 'package:flutter/material.dart';
import 'package:melembre/pages/HomePage.dart';
import 'package:flutter/services.dart';
import 'package:melembre/pages/splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MeLembreApp());
}

class MeLembreApp extends StatelessWidget {
  const MeLembreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurpleAccent[400],
          secondary: Colors.deepPurpleAccent[400],
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      routes: {
        '/splash': (_) => const SplashPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
