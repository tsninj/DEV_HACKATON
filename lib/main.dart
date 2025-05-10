import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartub/provider/globalProvider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // Бүх app-д Provider хүрэх боломжтой болгох
      create: (context) => Global_provider(),
      child: const MyApp()));
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
        '/': (context) => HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage()
      },
    );
  }
}