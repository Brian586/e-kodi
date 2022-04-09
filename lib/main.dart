import 'package:flutter/material.dart';
import 'package:rekodi/pages/home.dart';
import 'package:rekodi/pages/authPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Kodi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        "/auth": (context) => const AuthPage(),
      },
    );
  }
}
