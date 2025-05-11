import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../helpers/database_helper.dart';

// Map & location imports
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'services/location_service.dart';

class PostCard extends StatefulWidget {
  final String videoPath;
  final String location; // format: "lat, lng"
  final String caption;
  final String tags;
  final String timestamp;

  const PostCard({
    super.key,
    required this.videoPath,
    required this.location,
    required this.caption,
    required this.tags,
    required this.timestamp,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  VideoPlayerController? _videoController;
  bool isVideo = false;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  void _initializeMedia() {
    final file = File(widget.videoPath);
    if (file.existsSync()) {
      final ext = widget.videoPath.toLowerCase();
      if (ext.endsWith('.mp4') ||
          ext.endsWith('.mov') ||
          ext.endsWith('.avi')) {
        isVideo = true;
        _videoController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            if (mounted) setState(() {});
          }).catchError((e) {
            debugPrint("Error initializing video player: $e");
          });
      }
    } else {
      debugPrint("⚠️ File not found: ${widget.videoPath}");
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  /// Parse the saved "lat, lng" string into LatLng
  LatLng get _savedLatLng {
    final parts = widget.location
        .split(',')
        .map((s) => double.parse(s.trim()))
        .toList();
    return LatLng(parts[0], parts[1]);
  }

  /// Ensure permission & show map dialog with:
  ///  • white background
  ///  • TileLayer
  ///  • MarkerLayer(saved)
  ///  • CurrentLocationLayer(live)
  void _showMapDialog() async {
    try {
      // trigger permission prompt if needed
      await LocationService().getCurrentLocation();
    } catch (e) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Алдаа'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Хаах'),
            ),
          ],
        ),
      );
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Байршлууд'),
        titleTextStyle: TextStyle(color: Colors.black),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: FlutterMap(
            options: MapOptions(
              center: _savedLatLng,
              zoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yourcompany.app',
              ),
              MarkerLayer(
                markers: [
                  // Saved location
                  Marker(
                    point: _savedLatLng,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.place,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ],
              ),
              // Live/current device location
              CurrentLocationLayer(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Хаах'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagList = widget.tags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    return Card(
      color: Colors.white,  // ensure card is white
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video or image preview
          if (isVideo && _videoController != null && _videoController!.value.isInitialized)
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 48,
                  ),
                  onPressed: () {
                    setState(() {
                      _videoController!.value.isPlaying
                          ? _videoController!.pause()
                          : _videoController!.play();
                    });
                  },
                ),
              ],
            )
          else if (!isVideo)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.file(
                File(widget.videoPath),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            const SizedBox(
              height: 200,
              child: Center(child: Text("⚠️ Media not found")),
            ),

          // Post details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User & timestamp row
                Row(
                  children: [
                    const Icon(Icons.person, size: 40, color: Colors.grey),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "ner1",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        Text(
                          "mail@example.com",
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          _formatDate(widget.timestamp),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ► Tappable location row
                InkWell(
                  onTap: _showMapDialog,
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.location,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      const Icon(Icons.map, size: 16, color: Colors.blue),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Caption
                Text(
                  widget.caption,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),

                const SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 4,
                  children: tagList.map((tag) {
                    return TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff00A3E6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return "${_monthName(date.month)} ${date.day}";
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _monthName(int month) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month];
  }
}

class SavedEntriesScreen extends StatelessWidget {
  const SavedEntriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Нийтлэлүүд'),
        titleTextStyle: TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                _CategoryButton(label: "Бүгд", isSelected: true),
                _CategoryButton(label: "Муу усны нүх"),
                _CategoryButton(label: "Үед, ус"),
                _CategoryButton(label: "Гэрэл, цахилгаан"),
                _CategoryButton(label: "Хог хаягдал"),
                _CategoryButton(label: "Ногоон байгууламж"),
                _CategoryButton(label: "Барилга, байгууламж"),
                _CategoryButton(label: "Бусад"),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper.instance.fetchEntry(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нийтлэл алга байна.'));
                }

                final entries = snapshot.data!;

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return PostCard(
                      videoPath: entry['videoPath'],
                      location: entry['location'] ?? 'No location',
                      caption: entry['caption'] ?? 'No caption',
                      tags: entry['tag'] ?? 'No tags',
                      timestamp: entry['timestamp'] ?? 'No date',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryButton({super.key, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xff00A3E6) : Colors.white,
        minimumSize: const Size(5, 5),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }
}