import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'services/local_db.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(camera: firstCamera),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await _initializeControllerFuture;

                    final image = await _controller.takePicture();

                    if (!context.mounted) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DisplayPictureScreen(imagePath: image.path),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                onLongPress: () async {
                  setState(() { _isRecording = true; });
                  try {
                    await _initializeControllerFuture;
                    await _controller.startVideoRecording();
                  } catch (e) {
                    print('Error starting video recording: $e');
                  }
                },
                onLongPressUp: () async {
                  setState(() { _isRecording = false; });
                  try {
                    final video = await _controller.stopVideoRecording();
                    if (!context.mounted) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DisplayVideoScreen(videoPath: video.path),
                      ),
                    );
                  } catch (e) {
                    print('Error stopping video recording: $e');
                  }
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: _isRecording ? Colors.red : Colors.transparent,
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
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
    'Бусад'
  ];

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Таны илгээх асуудал",
                style: TextStyle(
                  fontSize: 12,
                  color: const Color.fromARGB(255, 118, 196, 247),
                )),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(tagNames.length, (index) {
                return ChoiceChip(
                  label: Text(
                    tagNames[index],
                    style: TextStyle(
                      color: selectedTags[index] ? Colors.black : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: selectedTags[index],
                  selectedColor: const Color.fromARGB(255, 189, 211, 242),
                  backgroundColor: Colors.white,
                  // optional: add a border so unselected chips don't blend in
                  side: BorderSide(
                    color: selectedTags[index] ? Colors.transparent : Colors.grey.shade300,
                  ),
                  onSelected: (bool sel) {
                    setState(() => selectedTags[index] = sel);
                  },
                );
              }),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: mapController,
              decoration: const InputDecoration(
                labelText: 'Хаяг',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: captionController,
              decoration: const InputDecoration(
                labelText: 'Тайлбар',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
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
                  await ReportDatabase.insertReport(
                    imagePath: widget.imagePath,
                    address: mapController.text,
                    caption: captionController.text,
                    tags: selectedTagTexts,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Амжилттай хадгалагдлаа')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 133, 198, 242),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text('Илгээх', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayVideoScreen extends StatelessWidget {
  final String videoPath;

  const DisplayVideoScreen({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Видео')),
      body: Center(child: Text('Видео файл: $videoPath')),
    );
  }
}