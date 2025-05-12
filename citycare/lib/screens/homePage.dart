// home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import '../providers/globalProvider.dart';
import 'report_screen.dart';
import '../screens/info_screen.dart';
import '../display.dart';
import 'post_sceen.dart';
import '../SavedEntriesScreen.dart';
import 'report_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<Widget> pages = [
    const VolunteerCardScreen(),
    const PostScreen(),
    const SavedEntriesScreen(),
    const InfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: pages[ provider.currentIdx == 1 ? 0 : provider.currentIdx ],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 197, 197, 197),
            currentIndex: provider.currentIdx,
            onTap: (int idx) async {
              if (idx == 1) {
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TakePictureScreen(camera: firstCamera),
                  ),
                );
              } else {
                provider.changeCurrentIdx(idx);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 35, color: Colors.white),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.feed_outlined, size: 35, color: Colors.white),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline, size: 45, color: Colors.white),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit_note_outlined, size: 35, color: Colors.white),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }
}