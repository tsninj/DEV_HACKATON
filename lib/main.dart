// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:smartub/provider/globalProvider.dart';
// import 'screens/home_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/register_screen.dart';
// import 'screens/info_screen.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       // Бүх app-д Provider хүрэх боломжтой болгох
//       create: (context) => Global_provider(),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Shop app',
//       initialRoute: '/',
//       routes: {
//         '/info': (context) => const InfoScreen(),
//         '/': (context) => HomePage(),
//         '/login': (context) => const LoginPage(),
//         '/signup': (context) => const SignUpPage(),
//       },
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'services/chimege_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Чимэгэ TTS Demo', home: const TtsHomePage());
  }
}

class TtsHomePage extends StatefulWidget {
  const TtsHomePage({super.key});
  @override
  State<TtsHomePage> createState() => _TtsHomePageState();
}

class _TtsHomePageState extends State<TtsHomePage> {
  final _textController = TextEditingController();
  String _voiceId = 'FEMALE3v2';
  double _speed = 1.0, _pitch = 1.0;
  final _player = AudioPlayer();
  bool _loading = false;

  Future<void> _speak() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() => _loading = true);
    try {
      Uint8List wav = await ChimegeService.synthesizeSpeech(
        text,
        voiceId: _voiceId,
        speed: _speed,
        pitch: _pitch,
      );
      await _player.play(BytesSource(wav));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Алдаа: \$e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чимэгэ TTS Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ярих текстээ оруулна уу',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Дуу хоолой:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _voiceId,
                  items:
                      [
                            'FEMALE1',
                            'FEMALE1v2',
                            'FEMALE2v2',
                            'FEMALE3v2',
                            'FEMALE4v2',
                            'FEMALE5v2',
                            'MALE1',
                            'MALE1v2',
                            'MALE2v2',
                            'MALE3v2',
                            'MALE4v2',
                          ]
                          .map(
                            (v) => DropdownMenuItem(value: v, child: Text(v)),
                          )
                          .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _voiceId = v);
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Хурд:'),
                Expanded(
                  child: Slider(
                    value: _speed,
                    min: 0.2,
                    max: 4.0,
                    divisions: 38,
                    label: _speed.toStringAsFixed(1),
                    onChanged: (v) => setState(() => _speed = v),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Өнгө:'),
                Expanded(
                  child: Slider(
                    value: _pitch,
                    min: 0.2,
                    max: 6.0,
                    divisions: 58,
                    label: _pitch.toStringAsFixed(1),
                    onChanged: (v) => setState(() => _pitch = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _speak,
              icon:
                  _loading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.volume_up),
              label: Text(_loading ? 'Ачааллаж байна...' : 'Ярих'),
            ),
          ],
        ),
      ),
    );
  }
}
