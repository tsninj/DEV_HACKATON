import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartub/provider/globalProvider.dart';
import 'report_screen.dart';
import 'volunteer_screen.dart';
import 'info_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Widget> pages = [
    ReportScreen(),
    const VolunteerScreen(),
    const InfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: pages[provider.currentIdx],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: provider.currentIdx,
            onTap: provider.changeCurrentIdx,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.report_gmailerrorred),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.volunteer_activism),
                label: 'Feedback',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Information',
              ),
            ],
          ),
        );
      },
    );
  }
}
