import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartub/provider/globalProvider.dart';
<<<<<<< HEAD
import '../../screens/home_screen.dart';
=======
import 'screens/home_screen.dart';
>>>>>>> d3382cd7dcc39f7fde462243ffbaeb9cc33f7fd5
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/info_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // Бүх app-д Provider хүрэх боломжтой болгох
      create: (context) => Global_provider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop app',
      initialRoute: '/',
      routes: {
        '/info': (context) => const InfoScreen(),
        '/': (context) => HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
      },
    );
  }
}
