import 'dart:io'; // ✅ Correct import
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../helpers/database_helper.dart';
import 'savedentriesscreen.dart';

class DisplayVideoScreen extends StatefulWidget {
  final String videoPath;
  final bool cameraOn=false;

  const DisplayVideoScreen({super.key, required this.videoPath});

  @override
  State<DisplayVideoScreen> createState() => _DisplayVideoScreenState();
}

class _DisplayVideoScreenState extends State<DisplayVideoScreen> {
  late VideoPlayerController _videoController;
  final TextEditingController mapController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  List<bool> selectedTags = List.generate(8, (index) => false);

  final List<String> tagNames = [
    'Муу усны нүх',
    'Үер ус',
    'Гэрэл, цахилгаан',
    'Зам',
    'Хог хаягдал',
    'Ногоон байгууламж',
    'Барилга, байгууламж',
    'Бусад',
  ];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    mapController.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Буцах'),
        titleTextStyle: const TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10, left: 20),
              child: Text(
                "Таны илгээх асуудал",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 118, 196, 247),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child:
                  _videoController.value.isInitialized
                      ? Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                      )
                      : const CircularProgressIndicator(),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 2,
                children: List.generate(tagNames.length, (index) {
                  return ChoiceChip(
                    label: Text(
                      tagNames[index],
                      style: TextStyle(
                        color:
                            selectedTags[index] ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: selectedTags[index],
                    selectedColor: const Color(0xff00A3E6),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color:
                          selectedTags[index]
                              ? Colors.transparent
                              : const Color(0xff00A3E6),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedTags[index] = selected;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 3,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: mapController,
                decoration: const InputDecoration(
                  labelText: 'Хаяг',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  labelText: 'Тайлбар',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final selectedTagTexts = <String>[];
                  for (int i = 0; i < selectedTags.length; i++) {
                    if (selectedTags[i]) selectedTagTexts.add(tagNames[i]);
                  }

                  await DatabaseHelper.instance.insertEntry(
                    widget.videoPath,
                    mapController.text,
                    captionController.text,
                    selectedTagTexts,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedEntriesScreen(),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Амжилттай хадгалагдлаа!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00A3E6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  'Илгээх',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
