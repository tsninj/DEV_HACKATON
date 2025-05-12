import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/globalProvider.dart';
import 'screens/homePage.dart';
 
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Global_provider(),
      child: const MyApp(),
    ),
  );
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(useMaterial3: false), debugShowCheckedModeBanner: false, home: HomePage());
  }
}