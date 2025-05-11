import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/info_model.dart';
import '../models/user_model1.dart';
import '../providers/globalProvider.dart';
import '../services/chimege_service.dart';
import '../widgets/information_view.dart';
import 'notif_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(
    ChangeNotifierProvider(
      create: (_) => Global_provider(),
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
      title: 'Info & TTS Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InfoScreen(),
    );
  }
}

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String selectedFilter = 'Бүгд';
  UserProfile? user;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final data = await rootBundle.loadString('assets/users.json');
    final jsonData = json.decode(data);
    setState(() => user = UserProfile.fromJson(jsonData));
  }

  Future<List<InfoModel>> _getData() async {
    final res = await rootBundle.loadString('assets/info.json');
    final list = InfoModel.fromList(json.decode(res));
    Provider.of<Global_provider>(context, listen: false).setInfos(list);
    return Provider.of<Global_provider>(context, listen: false).infos;
  }

  Future<void> _speakAll(List<InfoModel> items) async {
    if (items.isEmpty) return;
    final text = "Хотын утааг бууруулах санал. Хотын утааг бууруулах хөтөлбөрийн санал ирүүлнэ үү";
    try {
      Uint8List wav = await ChimegeService.synthesizeSpeech(text);
      await _player.play(BytesSource(wav));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TTS алдаа: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InfoModel>>(
      future: _getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final all = snapshot.data!;
        final filtered = all.where((i) => selectedFilter == 'Бүгд' || i.tag == selectedFilter).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF6F6F6),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF6F6F6),
            elevation: 0,
            title: const Text('Мэдээлэл', style: TextStyle(color: Colors.black)),
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 30),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                ),
              ),
            ],
          ),
          endDrawer: Drawer(
            backgroundColor: const Color(0xFFF6F6F6),
            child: user == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user!.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(user!.email, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          CircleAvatar(backgroundImage: AssetImage(user!.avatar), radius: 32),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
          ),
          body: Column(
            children: [
              // Filter row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Бүгд', 'Улс төр', 'Нийгэм', 'Эрүүл мэнд', 'Боловсрол']
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(f),
                              selected: f == selectedFilter,
                              onSelected: (_) => setState(() => selectedFilter = f),
                            ),
                          ))
                      .toList(),
                ),
              ),
              // Content list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: filtered.map((info) => InfoCard(data: info)).toList(),
                ),
              ),
              // Single button to speak all
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () => _speakAll(filtered),
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Ярих'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}