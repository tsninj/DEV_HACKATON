import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart'; 
import 'video.dart';
import 'savedentriesscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'services/location_service.dart';

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
                    debugPrint(e.toString());
                  }
                },
                onLongPress: () async {
                  setState(() {
                    _isRecording = true;
                  });
                  try {
                    await _initializeControllerFuture;
                    await _controller.startVideoRecording();
                  } catch (e) {
                    debugPrint("Error starting video recording: $e");
                  }
                },
                onLongPressUp: () async {
                  setState(() {
                    _isRecording = false;
                  });
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
                    debugPrint("Error stopping video recording: $e");
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
    'Бусад',
  ];

  @override
  void dispose() {
    mapController.dispose();
    captionController.dispose();
    super.dispose();
  }

  /// Байршлыг татаж, dialog-т харуулна.
  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<Position>(
          future: LocationService().getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                title: Text('Байршлыг тогтоож байна...'),
                titleTextStyle: TextStyle(color: Colors.black),
                content: SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Алдаа'),
                content: Text(snapshot.error.toString()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Хаах'),
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              final pos = snapshot.data!;
              return AlertDialog(
                title: const Text('Таны байршил'),
                titleTextStyle: TextStyle(color: Colors.black),
                content: Text(
                  'Өргөрөг: ${pos.latitude}\nУртраг: ${pos.longitude}',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        mapController.text =
                            '${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)}';
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Хаах'),
                  ),
                ],
              );
            } else {
              return const AlertDialog(
                title: Text('Тодорхойгүй алдаа'),
              );
            }
          },
        );
      },
    );
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
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 20),
              child: Text(
                "Таны илгээх асуудал",
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 118, 196, 247),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(widget.imagePath)),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 30),
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
                        color: selectedTags[index]
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: selectedTags[index],
                    selectedColor: const Color(0xff00A3E6),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: selectedTags[index]
                          ? Colors.transparent
                          : const Color(0xff00A3E6),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        selectedTags[index] = selected;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 3),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: mapController,
                      style: TextStyle(color: Colors.black),
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Хаяг',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.my_location,
                        color: Colors.blue),
                    onPressed: _showLocationDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: captionController,
                decoration: const InputDecoration(
                  labelText: 'Тайлбар',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius:
                        BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius:
                        BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (mapController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Эхлээд байршилын товчлуурыг дарна уу'),
                      ),
                    );
                    return;
                  }
                  final selectedTagTexts = <String>[];
                  for (int i = 0; i < selectedTags.length; i++) {
                    if (selectedTags[i]) {
                      selectedTagTexts.add(tagNames[i]);
                    }
                  }
                  await DatabaseHelper.instance.insertEntry(
                    widget.imagePath,
                    mapController.text,
                    captionController.text,
                    selectedTagTexts,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Амжилттай хадгалагдлаа!")),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedEntriesScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00A3E6),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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


            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
